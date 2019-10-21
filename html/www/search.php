<?php
header('Content-Type: text/html; charset=utf-8');

// Assertions
if ($_GET[address] == "" && ($_GET[lat] == "" || $_GET[lng] == "")) die('Missing parameter: address and (lat || lng)');
if ($_GET[distance] == "") die('Missing parameter: distance');
if ($_GET[offset] == "") $_GET[offset] = "0";
if ($_GET[format] == "") $_GET[format] = "html";

// Hardcoded variables:
$geocodingkey = "xxx";
$username = "zetanetuser";
$password = "xxx";
$perpage = "10";

// Connecting, selecting database
$link = mysqli_connect('localhost', $username, $password, 'zetanet_main');
            
// Check connection
if (mysqli_connect_errno())
    echo "Failed to connect to MySQL: " . mysqli_connect_error();
            
mysqli_set_charset($link, "utf8");

// Convert address to location
if ($_GET[address] != "")
{
    $url = "https://maps.googleapis.com/maps/api/geocode/json?key=$geocodingkey&address=".urlencode($_GET[address]);
    $object = json_decode(file_get_contents($url), false);
    $longitude = $object->results[0]->geometry->location->lng;
    $latitude = $object->results[0]->geometry->location->lat;
}
else
{
    $longitude = $_GET[lng];
    $latitude = $_GET[lat];
}

// Expand search request
foreach (str_getcsv($_GET[query], " ") as $search_each) 
{
    $search_sql .= "AND contentcache LIKE '%$search_each%'";
}

// Performing SQL query
$querycore = "MBRContains(LineString(Point($longitude + $_GET[distance] / (111.1 / COS(RADIANS($latitude))), $latitude + $_GET[distance] / 111.1), Point($longitude - $_GET[distance] / (111.1 / COS(RADIANS($latitude))), $latitude - $_GET[distance] / 111.1)), position) AND NOW() < expiration $search_sql";

$querycount = "SELECT count(1) FROM post WHERE ".$querycore;

$resultcount = mysqli_query($link, $querycount);
                                        
if (! $resultcount)
    echo "Query failed: " . mysqli_error($link);

$query = "SELECT url, timeline, expiration, titlecache, positioncache, contentcache, imageurlcache, ST_Distance(position, Point($longitude, $latitude)) as distance FROM post WHERE ".$querycore." ORDER BY distance LIMIT $_GET[offset], $perpage";

$result = mysqli_query($link, $query);
                                        
if (! $result)
    echo "Query failed: " . mysqli_error($link);

switch ($_GET[format])
{
// Printing results in HTML
case "html":
    echo "<html>\n";
    echo "    <head>\n";
    echo "        <title>ZetaNet - Search</title>\n";
    echo "        <link rel=\"stylesheet\" href=\"main.css\">\n";
    echo "        <link rel=\"stylesheet\" href=\"slideshow.css\">\n";
    echo "        <script src=\"slideshow.js\"></script>\n";
    echo "    </head>\n";
    echo "    <body>\n";

    echo "<table cellspacing='8px'>\n";
    
    $i = 0;
    while ($line = mysqli_fetch_array($result, MYSQLI_ASSOC))
    {
        if ($line[titlecache] == "")
            $line[titlecache] = "&lt;Untitled&gt;";

        echo "    <tr>\n";
        echo "        <td width='60px'>\n";
        echo "        </td>\n";
        echo "        <td width='80px' height='80px'>\n";
        
        echo "            <div class=\"slideshow-container\">\n";

        $j = 0;
        foreach (array_filter(explode(" ", $line[imageurlcache])) as $imageurl)
        {
            echo "                <div class=\"recordslide".$i." fade\">\n";
            echo "                    <img src=\"$imageurl\" style=\"width:100%; height:100%; object-fit: cover;\">\n";
            echo "                </div>\n";
            
            ++ $j;
        }

        if ($j > 0)
        {
            echo "                <script>var recordindex".$i." = 0;</script>\n";
            
            if ($j > 1)
            {
                echo "                <a class=\"prev\" onclick=\"recordindex".$i." = showSlides(document.getElementsByClassName('recordslide".$i."'), recordindex".$i." - 1)\">&#10094;</a>\n";
                echo "                <a class=\"next\" onclick=\"recordindex".$i." = showSlides(document.getElementsByClassName('recordslide".$i."'), recordindex".$i." + 1)\">&#10095;</a>\n";
            }
            
            echo "                <script>showSlides(document.getElementsByClassName('recordslide".$i."'), recordindex".$i.");</script>\n";
        }
        
        echo "            </div>\n";

        echo "        </td>\n";
        echo "        <td>\n";
        echo "            <a href='$line[url]'>$line[titlecache]</a><br>\n";
        echo "            <font color='green'>$line[positioncache]<br></font>\n";
        echo "            <font color='gray'><i>(until $line[expiration])</i><br></font>\n";
        echo "            <br>\n";
        echo "        </td>\n";
        echo "    </tr>\n";
        
        ++ $i;
    }
    echo "</table>\n";

    $j = mysqli_fetch_array($resultcount)[0] / $perpage;

    echo "<table align='center'>\n";
    echo "    <tr>\n";
    for ($i = 0; $i < $j; $i ++)
    {
        echo "    <td>\n";
        $k = $i * $perpage;
        $l = $i + 1;
        
        if ($k == $_GET[offset])
            echo $l;
        else
            echo "        <a href='search?query=$_GET[query]&address=$_GET[address]&distance=$_GET[distance]&offset=$k'>$l</a>\n";
        echo "    </td>\n";
    }
    echo "    </tr>\n";
    echo "</table>\n";

    echo "    </body>\n";
    echo "</html>\n";
    break;
    
// Printing results in JSON
case "json":
    echo "[\n";
    $i = 0;
    while ($line = mysqli_fetch_array($result, MYSQLI_ASSOC))
    {
        if ($i ++ != 0)
            echo "\t,\n";
        
        echo "\t{\n";
        echo "\t\t\"url\": \"$line[url]\",\n";
        echo "\t\t\"timeline\": \"$line[timeline]\",\n";
        echo "\t\t\"expiration\": \"$line[expiration]\",\n";
        echo "\t\t\"titlecache\": ".json_encode($line[titlecache]).",\n";
        echo "\t\t\"positioncache\": \"".$line[positioncache]."\",\n";
        echo "\t\t\"imageurlcache\": \"".$line[imageurlcache]."\"\n";
        echo "\t}\n";
    }
    echo "]\n";
    break;
}


// Free resultset
mysqli_free_result($result);

// Closing connection
mysqli_close($link);
?>
