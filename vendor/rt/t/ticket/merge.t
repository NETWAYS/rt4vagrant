
use strict;
use warnings;


use RT;
use RT::Test tests => '44';


# validate that when merging two tickets, the comments from both tickets
# are integrated into the new ticket
{
    my $queue = RT::Queue->new(RT->SystemUser);
    my ($id,$msg) = $queue->Create(Name => 'MergeTest-'.rand(25));
    ok ($id,$msg);

    my $t1 = RT::Ticket->new(RT->SystemUser);
    my ($tid,$transid, $t1msg) =$t1->Create(
        Queue => $queue->Name,
        Subject => 'Merge test. orig',
    );
    ok ($tid, $t1msg);
    ($id, $msg) = $t1->Comment(Content => 'This is a Comment on the original');
    ok($id,$msg);

    my $txns = $t1->Transactions;
    my $Comments = 0;
    while (my $txn = $txns->Next) {
    $Comments++ if ($txn->Type eq 'Comment');
    }
    is($Comments,1, "our first ticket has only one Comment");

    my $t2 = RT::Ticket->new(RT->SystemUser);
    my ($t2id,$t2transid, $t2msg) =$t2->Create ( Queue => $queue->Name, Subject => 'Merge test. duplicate');
    ok ($t2id, $t2msg);



    ($id, $msg) = $t2->Comment(Content => 'This is a commet on the duplicate');
    ok($id,$msg);


    $txns = $t2->Transactions;
     $Comments = 0;
    while (my $txn = $txns->Next) {
        $Comments++ if ($txn->Type eq 'Comment');
    }
    is($Comments,1, "our second ticket has only one Comment");

    ($id, $msg) = $t1->Comment(Content => 'This is a second  Comment on the original');
    ok($id,$msg);

    $txns = $t1->Transactions;
    $Comments = 0;
    while (my $txn = $txns->Next) {
        $Comments++ if ($txn->Type eq 'Comment');
    }
    is($Comments,2, "our first ticket now has two Comments");

    ($id,$msg) = $t2->MergeInto($t1->id);

    ok($id,$msg);
    $txns = $t1->Transactions;
    $Comments = 0;
    while (my $txn = $txns->Next) {
        $Comments++ if ($txn->Type eq 'Comment');
    }
    is($Comments,3, "our first ticket now has three Comments - we merged safely");
}

# when you try to merge duplicate links on postgres, eveyrything goes to hell due to referential integrity constraints.
{
    my $t = RT::Ticket->new(RT->SystemUser);
    $t->Create(Subject => 'Main', Queue => 'general');

    ok ($t->id);
    my $t2 = RT::Ticket->new(RT->SystemUser);
    $t2->Create(Subject => 'Second', Queue => 'general');
    ok ($t2->id);

    my $t3 = RT::Ticket->new(RT->SystemUser);
    $t3->Create(Subject => 'Third', Queue => 'general');

    ok ($t3->id);

    my ($id,$val);
    ($id,$val) = $t->AddLink(Type => 'DependsOn', Target => $t3->id);
    ok($id,$val);
    ($id,$val) = $t2->AddLink(Type => 'DependsOn', Target => $t3->id);
    ok($id,$val);

    ($id,$val) = $t->MergeInto($t2->id);
    ok($id,$val);
}

my $user = RT::Test->load_or_create_user(
    Name => 'a user', Password => 'password',
);
ok $user && $user->id, 'loaded or created user';

# check rights
{
    RT::Test->set_rights(
        { Principal => 'Everyone', Right => [qw(SeeQueue ShowTicket CreateTicket OwnTicket TakeTicket)] },
        { Principal => 'Owner',    Right => [qw(ModifyTicket)] },
    );

    my $t = RT::Ticket->new(RT::CurrentUser->new($user));
    $t->Create(Subject => 'Main', Queue => 'general');
    ok ($t->id, "Created ticket");

    my $t2 = RT::Ticket->new(RT::CurrentUser->new($user));
    $t2->Create(Subject => 'Second', Queue => 'general');
    ok ($t2->id, "Created ticket");

    foreach my $ticket ( $t, $t2 ) {
        ok( !$ticket->CurrentUserHasRight('ModifyTicket'), "can not modify" );
    }

    my ($status,$msg) = $t->MergeInto($t2->id);
    ok(!$status, "Can not merge: $msg");
    
    ($status, $msg) = $t->SetOwner( $user->id );
    ok( $status, "User took ticket");
    ok( $t->CurrentUserHasRight('ModifyTicket'), "can modify after take" );

    ($status,$msg) = $t->MergeInto($t2->id);
    ok(!$status, "Can not merge: $msg");

    ($status, $msg) = $t2->SetOwner( $user->id );
    ok( $status, "User took ticket");
    ok( $t2->CurrentUserHasRight('ModifyTicket'), "can modify after take" );

    ($status,$msg) = $t->MergeInto($t2->id);
    ok($status, "Merged tickets: $msg");
}

# check Time* fields after merge
{
    my @tickets;
    my @values = (
        { Worked => 11, Estimated => 17, Left => 6 },
        { Worked => 7, Estimated => 12, Left => 5 },
    );

    for my $i (0 .. 1) {
        my $t = RT::Ticket->new(RT->SystemUser);
        $t->Create( Queue => 'general');
        ok ($t->id);
        push @tickets, $t;

        foreach my $field ( keys %{ $values[ $i ] } ) {
            my $method = "SetTime$field";
            my ($status, $msg) = $t->$method( $values[ $i ]{ $field } );
            ok $status, "changed $field on the ticket"
                or diag "error: $msg";
        }
    }

    my ($status, $msg) = $tickets[1]->MergeInto($tickets[0]->id);
    ok($status,$msg);

    my $t = RT::Ticket->new(RT->SystemUser);
    $t->Load( $tickets[0]->id );
    foreach my $field ( keys %{ $values[0] } ) {
        my $method = "Time$field";
        my $expected = 0;
        $expected += $_->{ $field } foreach @values;
        is $t->$method, $expected, "correct value";

        my $from_history = 0;
        my $txns = $t->Transactions;
        while ( my $txn = $txns->Next ) {
            next unless $txn->Type eq 'Set' && $txn->Field eq $method;
            $from_history += $txn->NewValue - $txn->OldValue;
        }
        is $from_history, $expected, "history is correct";
    }
}
