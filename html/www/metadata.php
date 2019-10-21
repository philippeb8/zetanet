<?php
function get_title($url) 
{ 
    /* Get data */
    $html = @file_get_contents($url);

    if ( ($html !== false) && (strlen($html) ) > 0) 
    {
        /* Find title match */
        preg_match("/\<title(.*)\>(.*)\<\/title\>/i", $html, $title);
        
        /* Title match */
        $title = $title[2];

        /* Remove breaks and white space */
        $title = trim(preg_replace('/\s+/', ' ', $title));
    }

    return ( ($html !== false) && ($title != '') ) ? $title : (boolean) false;
}

function meta_data($url, $type = '') 
{
    /* Request. Consider CURL */
    $data = @file_get_contents($url);

    /* Only parse betwen head tags */
    preg_match_all('/<head>(.*?)<\/head>/si', $data, $head);
    $data = $head['0']['0'];

    if ($data !== false) 
    {
        /* Get all tags */
        preg_match_all('/<[\s]*meta[\s]*(name|property)="?'.'([^>"]*)"?[\s]*'.'content="?([^>"]*)"?[\s]*[\/]?[\s]*>/si', $data, $match);
        
        $count = count($match['3']);

        for ($i = 0; $i < $count; $i ++)
        {
            $key = $match['2'][$i];
            $key = trim($key);

            $value = $match['3'][$i];
            $value = trim($value);

            /* Create array/key combo */
            if (is_null($return[$key]))
            {
                $return[$key] = array();
            }

            array_push($return[$key], $value);
        }
    } 
 
    /* If data, return it, otherwise returns false */
    return ($return !== false) ? ($type) ? $return[$type] : $return : false;
}
?>