<?php
$lang = "en";
$hostUrl = "https://host.zetanet.org/";

echo "<html>\n";
echo "    <head>\n";
echo "        <title>" . $_POST[title] . "</title>\n";
echo "        <link rel=\"stylesheet\" href=\"main.css\">\n";
echo "        <link rel=\"stylesheet\" href=\"slideshow.css\">\n";
echo "        <script src=\"slideshow.js\"></script>\n";
echo "        <meta property=\"og:title\" content=\"" . $_POST[title] . "\">\n";
echo "        <meta property=\"og:type\" content=\"website\">\n";

$imageid = array_filter(explode(" ", $_POST[imageid]));

for ($j = 0; $j < count($imageid); ++ $j)
    echo "        <meta property=\"og:image\" content=\"" . $hostUrl . "getimage?imageid=" . $imageid[$j] . "\">\n";

echo "        <meta name=\"viewport\" content=\"width=device-width,height=device-height,initial-scale=1.0\"/>\n";
echo "    </head>\n";
echo "    <body>\n";
echo "        <br>\n";

if (count($imageid) > 0)
{
    echo "        <table align=\"center\">\n";
    echo "            <tr>\n";
    echo "                <td width='240px' height='240px'>\n";
    echo "                    <div class=\"slideshow-container\">\n";

    for ($k = 0; $k < count($imageid); ++ $k)
    {
        echo "                        <div class=\"recordslide" . 0 . " fade\">\n";
        echo "                            <img src=\"getimage?imageid=" . $imageid[$k] . "\" style=\"width:100%; height:100%; object-fit: cover;\">\n";
        echo "                        </div>\n";
    }

    echo "                        <script>var recordindex" . 0 . " = 0;</script>\n";

    if (count($imageid) > 1)
    {
        echo "                        <a class=\"prev\" onclick=\"recordindex" . 0 . " = showSlides(document.getElementsByClassName('recordslide" . 0 . "'), recordindex" . 0 . " - 1)\">&#10094;</a>\n";
        echo "                        <a class=\"next\" onclick=\"recordindex" . 0 . " = showSlides(document.getElementsByClassName('recordslide" . 0 . "'), recordindex" . 0 . " + 1)\">&#10095;</a>\n";
    }

    echo "                        <script>showSlides(document.getElementsByClassName('recordslide" . 0 . "'), recordindex" . 0 . ");</script>\n";

    echo "                    </div>\n";
    echo "                </td>\n";
    echo "            </tr>\n";
    echo "        </table>\n";
    echo "        <br>\n";

    if (count($imageid) > 1)
    {
        echo "        <table align=\"center\">\n";
        echo "            <tr>\n";

        for ($l = 0; $l < count($imageid); ++ $l)
        {
            echo "                <td width='80px' height='80px'>\n";
            echo "                    <img src=\"getimage?imageid=" . $imageid[$l] . "\" style=\"width:100%; height:100%; object-fit: cover;\" onclick=\"recordindex" . 0 . " = showSlides(document.getElementsByClassName('recordslide" . 0 . "'), " . $l . ")\">\n";
            echo "                </td>\n";
        }

        echo "            </tr>\n";
        echo "        </table>\n";
        echo "        <br>\n";
    }
}

echo "        <div style=\"text-align:center; width:100%;\">\n";
echo "            <iframe frameborder=\"0\" style=\"border:0\" src=\"//www.google.com/maps/embed/v1/place?key=AIzaSyDrsyte2iMw8ff7N-7cf6bHi1Xe6fee0c0&q=" . ($_POST[address] != "" ? urlencode($_POST[address]) : ($_POST[latitude] . "," . $_POST[longitude])) . "\" allowfullscreen>\n";
echo "            </iframe>\n";
echo "        </div>\n";
echo "        <br>\n";

echo "        <table align=\"center\">\n";
echo "            <tr>\n";
echo "                <td>\n";

echo "                    <h1>" . $_POST[title] . "</h1>\n";
echo "                    <br>\n";
echo nl2br($_POST[body]);

echo "                </td>\n";
echo "            </tr>\n";
echo "        </table>\n";
echo "        <br>\n";

if ($_POST[email] != "")
{
    echo "        <form action=\"validatemail\" method=\"post\">\n";
    echo "            <div class=\"searchbar\">\n";
    echo "                <input id=\"search1\" type=\"text\" name=\"from\" placeholder=\"From (email address)\">\n";
    echo "                <input id=\"search2\" type=\"hidden\" name=\"to\" placeholder=\"To (email address)\" value=\"$_POST[siteid]\">\n";
    echo "                <input id=\"search3\" type=\"text\" name=\"subject\" placeholder=\"Subject\"  value=\"Re: $_POST[title]\">\n";
    echo "                <textarea id=\"message1\" type=\"text\" name=\"message\" placeholder=\"Message\" style=\"resize: none;\"></textarea>\n";
    echo "            </div>\n";
    echo "            <div class=\"g-recaptcha\" data-sitekey=\"6Ld85yYUAAAAAKG8CJWVENtVKCM_has8S7itH6Hs\"></div>\n";
    echo "            <div id=\"buttons\">\n";
    echo "                <input class=\"button\" type=\"submit\">\n";
    echo "            </div>\n";
    echo "        </form>\n";
    echo "        <br>\n";
}

echo "        <script type=\"text/javascript\" src=\"https://www.google.com/recaptcha/api.js?hl=<?php echo $lang;?>\">\n";
echo "        </script>\n";

echo "    </body>\n";
echo "</html>\n";
?>