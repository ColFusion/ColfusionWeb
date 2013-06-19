<?php
$result;
//echo exec("\"C:\\inetpub\\WorldHistoryWiki\\svc\\java.exe -jar \"C:\\inetpub\\WorldHistoryWiki\\kettle-data-integration\\launcher\\launcher.jar\" -main org.pentaho.di.pan.Pan",$result);
//echo exec("\"C:\\Program Files (x86)\\Java\\jre6\\bin\\java.exe\" -jar \"C:\\inetpub\\WorldHistoryWiki\\kettle-data-integration\\launcher\\launcher.jar\" -main org.pentaho.di.pan.Pan",$result);
//print_r($result);
//"C:\Program Files (x86)\Java\jre6\bin\java.exe" -jar "C:\inetpub\WorldHistoryWiki\kettle-data-integration\launcher\launcher.jar" -main org.pentaho.di.pan.Pan

//$cmd='cmd.exe /C PanMark.bat';
$cmd='cmd.exe /C C:\\inetpub\\WorldHistoryWiki\\kettle-data-integration\\Pan_WHDV.bat /file:"C:\\inetpub\\WorldHistoryWiki\\registered-wrappers\\excel_to_target_schema.ktr"';
echo "Command:[$cmd]<br />\n";
exec($cmd,$result);
print_r($result);


?>