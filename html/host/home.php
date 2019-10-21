<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>ZetaNet</title>
        <link rel="stylesheet" href="main.css">
        <meta property="og:title" content="ZetaNet">
        <meta property="og:type" content="website">
        <meta property="og:image" content="https://www.zetanet.org/images/logo.png">
        <meta property="og:image:width" content="177">
        <meta property="og:image:height" content="106">
        <meta name="viewport" content="width=device-width,height=device-height,initial-scale=1.0"/>
    </head>
    <body>
        <?php 
            error_reporting(E_ALL ^ E_WARNING);
            
            if (empty($_SESSION))
                session_start();

            if (! isset($_SESSION['username']))
                echo "<script language='javascript' type='text/javascript'> location.href='login' </script>";    
            else
            {
                $login_session=$_SESSION['username'];
                echo $login_session;
            }
        ?>
        <a href="logout.php"> Logout </a>
    </body>
</html>
