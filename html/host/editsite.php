<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>ZetaNet</title>
        <link rel="stylesheet" href="main.css">
        <meta property="og:title" content="ZetaNet">
        <meta property="og:type" content="website">
        <meta property="og:image" content="https://www.zetanet.org/images/logo.png">
        <meta property="og:image:width" content="177">
        <meta property="og:image:height" content="106">
        <script src="ckeditor/ckeditor.js"></script>
        <meta name="viewport" content="width=device-width,height=device-height,initial-scale=1.0"/>
    </head>
    <body>
        <?php
            if (empty($_SESSION))
                session_start();

            if (! isset($_SESSION['username'])) 
                echo "<script language='javascript' type='text/javascript'> location.href='login' </script>";    
        ?>
        <form action="updatesite" method="post">
            <textarea name="html" id="editor1">
                <?php 
                    echo htmlspecialchars(file_get_contents("https://host.zetanet.org/getsite?siteid=$_GET[siteid]"), ENT_QUOTES) 
                ?>
            </textarea>
            <input type="hidden" name="siteid" value="<?php echo $_GET[siteid] ?>"/>
            <div id="buttons">
                <input class="button" type="submit">
            </div>
            <script>
                CKEDITOR.replace( 'editor1' );
            </script>
        </form>
    </body>
</html>