#!/bin/sh
#
# ENVARS for Tomcat
#
CATALINA_HOME="/usr/share/tomcat8"

export CATALINA_HOME

CATALINA_BASE="/var/lib/tomcat8"

export CATALINA_BASE

JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/jre"

export JAVA_HOME

# TDS specific ENVARS
#
# Define where the TDS content directory will live
#   THIS IS CRITICAL and there is NO DEFAULT - the
#   TDS will not start without this.
#
# IMPORTANT: DO NOT FORGET TO SET PROPER WRITE PERMISSIONS FOR THIS DIRECTORY
CONTENT_ROOT=-Dtds.content.root.path=/var/lib/tomcat8/content

# set java prefs related variables (used by the wms service, for example)
JAVA_PREFS_ROOTS="-Djava.util.prefs.systemRoot=$CATALINA_BASE/content/thredds/javaUtilPrefs \
                  -Djava.util.prefs.userRoot=$CATALINA_BASE/content/thredds/javaUtilPrefs"

#
# Some commonly used JAVA_OPTS settings:
#
NORMAL="-d64 -Xmx4096m -Xms512m -server -ea"
HEAP_DUMP="-XX:+HeapDumpOnOutOfMemoryError"
HEADLESS="-Djava.awt.headless=true"

#
# Standard setup.
#
CATALINA_OPTS="$CONTENT_ROOT $NORMAL $MAX_PERM_GEN $HEAP_DUMP $HEADLESS $JAVA_PREFS_ROOTS"

export CATALINA_OPTS
