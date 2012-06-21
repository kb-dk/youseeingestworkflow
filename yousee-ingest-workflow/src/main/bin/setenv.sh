[ -z "$TAVERNA_HOME" ] && TAVERNA_HOME="$HOME/taverna/taverna-workbench-2.4.0"
export TAVERNA_HOME

[ -z "$JAVA_HOME" ] && JAVA_HOME="/usr/java/jdk1.6.0_32"
export JAVA_HOME


[ -z "$YOUSEE_HOME" ] && YOUSEE_HOME="$HOME/yousee-workflow/services/workflow"
export YOUSEE_HOME

[ -z "$YOUSEE_CONFIG" ] && YOUSEE_CONFIG="${yousee.config}"
export YOUSEE_CONFIG

[ -z "$YOUSEE_WORKFLOW_CONFIG" ] && YOUSEE_WORKFLOW_CONFIG="$YOUSEE_CONFIG/${yousee.workflow.config}"
export YOUSEE_WORKFLOW_CONFIG

[ -z "$YOUSEE_LOGS" ] && YOUSEE_LOGS="$HOME/${yousee.logs}"
export YOUSEE_LOGS

[ -z "$YOUSEE_LOCKS" ] && YOUSEE_LOCKS="$HOME/var/${yousee.locks}"
export YOUSEE_LOCKS

[ -z "$YOUSEE_COMPONENTS" ] && YOUSEE_COMPONENTS="$YOUSEE_HOME/${yousee.components.dir}"
export YOUSEE_COMPONENTS

[ -z "$YOUSEE_SCRIPTS" ] && YOUSEE_SCRIPTS="$YOUSEE_HOME/${yousee.script.dir}"
export YOUSEE_SCRIPTS

[ -z "$YOUSEE_WORKFLOWS" ] && YOUSEE_WORKFLOWS="$YOUSEE_HOME/${yousee.workflow.dir}"
export YOUSEE_WORKFLOWS

[ -z "$YOUSEE_DEPENDENCIES" ] && YOUSEE_DEPENDENCIES="$YOUSEE_HOME/${yousee.workflow.dependencies}"
export YOUSEE_DEPENDENCIES

[ -z "$YOUSEE_BIN" ] && YOUSEE_BIN="$YOUSEE_HOME/${yousee.bin}"
export YOUSEE_BIN
