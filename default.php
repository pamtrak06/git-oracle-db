<?
##########  DEFINITIONS
set_time_limit(0);
$CURR_LOG='';
$CURR_SESSION='DEFAULT';
$CONNECT_POOL=array();
$normal_errors=array(24344,955,1917,942);#errors to ignore
$normal_errors[]=20102;
$CONNECTS=array('DEFAULT'=>array('scheme'=>'magic','pass'=>'oracle','connect'=>'//oracle-xe:1521/sid','enc'=>'AL32UTF8','mode'=>OCI_DEFAULT),);#your oracle connection settings
define('VERBOSE',0);
define('DEBUG',1);
$bkp_dir = '/repo/default.git/';#define a directory to store your git repo
#$LOGS_CONVERSION=array('from'=>"Windows-1251",'to'=>"utf-8"); #convert GIT logs to utf if you need it.k
?>
