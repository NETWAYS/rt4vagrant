#!/bin/bash

apt-get update && apt-get dist-upgrade -y -u \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    autoconf \
    build-essential \
    locales \
    cpanminus \
    libmysqlclient-dev \
    libmysqlclient20 \
    \
    libhtml-mason-perl \
    libapache-session-perl \
    libregexp-common-perl \
    libdbi-perl \
    libdbix-searchbuilder-perl \
    libtext-template-perl \
    liblog-dispatch-perl \
    liblocale-maketext-fuzzy-perl \
    liblocale-maketext-lexicon-perl \
    libmime-tools-perl \
    libmime-types-perl \
    libmailtools-perl \
    libtext-wrapper-perl \
    libtime-modules-perl \
    libtext-autoformat-perl \
    libtext-wikiformat-perl \
    libhtml-scrubber-perl \
    libmodule-versions-report-perl \
    libtree-simple-perl \
    libxml-rss-perl \
    libxml-simple-perl \
    libgd-graph-perl \
    libuniversal-require-perl \
    libgd-text-perl \
    libtimedate-perl \
    libfile-sharedir-perl \
    libemail-address-perl \
    libperlio-eol-perl \
    libdata-ical-perl \
    libtext-quoted-perl \
    libhtml-rewriteattributes-perl \
    libgraphviz-perl \
    libgnupg-interface-perl \
    libencode-perl \
    libcgi-pm-perl \
    libfcgi-procmanager-perl \
    libdatetime-perl \
    libdatetime-locale-perl \
    libhtml-quoted-perl \
    libfile-temp-perl \
    libtext-password-pronounceable-perl \
    libdevel-globaldestruction-perl \
    liblist-moreutils-perl \
    libnet-cidr-perl \
    libregexp-common-net-cidr-perl \
    libregexp-ipv6-perl \
    libjson-perl \
    libipc-run3-perl \
    libcgi-psgi-perl \
    libhtml-mason-psgihandler-perl \
    libplack-perl \
    libcgi-emulate-psgi-perl \
    libconvert-color-perl \
    libclass-accessor-perl \
    liburi-perl \
    libipc-run-perl \
    libcrypt-eksblowfish-perl \
    libdata-guid-perl \
    libdate-extract-perl \
    libdate-manip-perl \
    libdatetime-format-natural-perl \
    libemail-address-list-perl \
    libhtml-formattext-withlinks-perl \
    libhtml-formattext-withlinks-andtables-perl \
    libhttp-message-perl \
    libwww-perl \
    libmodule-refresh-perl \
    librole-basic-perl \
    libsymbol-global-name-perl \
    libfile-which-perl \
    libcrypt-x509-perl \
    libstring-shellquote-perl \
    libcrypt-ssleay-perl \
    libcss-squish-perl \
    libdatetime-locale-perl \
    libdatetime-perl \
    libnet-ssleay-perl \
    libnet-ldap-perl

cpanm --notest --installdeps /vagrant/.provision

