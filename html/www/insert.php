<?php
header('Content-Type: text/html; charset=utf-8');
header('Access-Control-Allow-Origin: *');
require("metadata.php");

// Assertions
if ($_POST[address] == "" && ($_POST[lat] == "" || $_POST[lng] == "")) die('Missing parameter: address and (lat || lng)');
if ($_POST[expiration] == "") $_POST[expiration] = date("Y-m-d H:i:s", PHP_INT_MAX);
if ($_POST[url] == "") die('Missing parameter: url');

$_POST[url] = format_url($_POST[url]);
    
// Hardcoded variables:
$geocodingkey = "xxx";
$username = "zetanetuser";
$password = "xxx";

// Connecting, selecting database
$link = mysqli_connect('localhost', $username, $password, 'zetanet_main');

// Check connection
if (mysqli_connect_errno())
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
            
mysqli_set_charset($link, "utf8");

// Convert address to location
if ($_POST[address] != "")
    $url = "https://maps.googleapis.com/maps/api/geocode/json?key=$geocodingkey&address=".urlencode($_POST[address]);
else
    $url = "https://maps.googleapis.com/maps/api/geocode/json?key=$geocodingkey&latlng=".$_POST[lat].",".$_POST[lng];
$object = json_decode(file_get_contents($url), false);
$longitude = $object->results[0]->geometry->location->lng;
$latitude = $object->results[0]->geometry->location->lat;
$positioncache = $object->results[0]->formatted_address;

$result = array();

crawl($_POST[url], $_POST[url], $result);
    
foreach ($result as $url) 
{
    $contentcache .= any2text($url);
}

$url = $result[0];

if ($url != "")
{
    $title = get_title($url);

    foreach (meta_data($url, "og:image") as $imageurl) 
    {
        $imageurlcache .= " ".$imageurl;
    }

    $imageurlcache = trim($imageurlcache);

    // Performing SQL query
    $query = "INSERT INTO post (url, timeline, expiration, position, titlecache, positioncache, contentcache, imageurlcache) VALUES ('".addslashes($url)."', NOW(), '$_POST[expiration]', Point($longitude, $latitude), '".addslashes($title)."', '".addslashes($positioncache)."', '".addslashes($contentcache)."', '".addslashes($imageurlcache)."') ON DUPLICATE KEY UPDATE timeline=NOW(), expiration='$_POST[expiration]', position=Point($longitude, $latitude), titlecache='".addslashes($title)."', positioncache='".addslashes($positioncache)."', contentcache='".addslashes($contentcache)."', imageurlcache='".addslashes($imageurlcache)."'";

    $result = mysqli_query($link, $query);
                                        
    if (! $result)
        echo "Query failed: " . mysqli_error($link);

    echo "'$url' successfully added.\n";
}
else
{
    echo "'$_POST[url]' skipped.\n";
}

// Closing connection
mysqli_close($link);
?>
