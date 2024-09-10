<?php
require "/opt/FileMaker/JDBC/php/PJBridge.php";

// Default
$host = 'localhost';
$port = '4444';

// Get username/password and database from cli
$user = $argv[1];
$password = $argv[2];
$database = $argv[3];

// Get SQL query to execute from CLI
$sql = $argv[4];

// Try to create a connection
$bridge = new PJBridge($host, $port, 'utf-8', 'utf-8');
$connectString = "jdbc:filemaker://$host/$database";
$connection = $bridge->connect($connectString, $user, $password);
if (!$connection) {
    throw new Exception("JDBC Connection failed to resolve...");
}

// Try to receive data
$cursor = $bridge->exec($sql);

// Check if any data has been received
if(!$cursor){
    throw new Exeception("No data returned from query. Are you sure the query is correctly formatted?");
}

// Print received data
while($row = $bridge->fetch_array($cursor)){
      print_r($row);
}
$bridge->free_result($cursor);
