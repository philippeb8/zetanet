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
        <meta name="viewport" content="width=device-width,height=device-height,initial-scale=1.0"/>
    </head>
    <body>
        <div class="overlay">
            <div class="loader"></div>
        </div>
        <script type="text/javascript">
            var image = [];
            
            function previewFiles() 
            {
                var preview = document.querySelector('#preview');
                var data    = document.querySelector('#data');
                var files   = document.querySelector('input[type=file]').files;

                function readAndPreview(file) 
                {
                    // Make sure `file.name` matches our extensions criteria
                    if ( /\.(jpe?g|png|gif)$/i.test(file.name) ) 
                    {
                        var reader1 = new FileReader();
                        var reader2 = new FileReader();

                        reader1.addEventListener
                        (
                            "load", 
                            function () 
                            {
                                var image = new Image();
                                image.height = 100;
                                image.title = file.name;
                                image.src = this.result;
                                preview.appendChild(image);
                            }, 
                            false
                        );
                        reader2.addEventListener
                        (
                            "load", 
                            function () 
                            {
                                image.push(this.result);
                            }, 
                            false
                        );

                        reader1.readAsDataURL(file);
                        reader2.readAsBinaryString(file);
                    }
                }
                
                image = [];

                if (files) 
                {
                    [].forEach.call(files, readAndPreview);
                }
            }
            
            function submitPage()
            {
                document.querySelector(".overlay").style.display = "initial";
                
                setTimeout
                (
                    function()
                    {
                        var apiurl  = "https://www.zetanet.org/";
                        var hosturl = "https://host.zetanet.org/";
                        var imageid = [];
                        
                        // post images
                        for (var i = 0; i < image.length; ++ i)
                        {
                            var http1 = new XMLHttpRequest();

                            http1.open("POST", hosturl + "insertimage", false);
                            http1.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                            http1.onreadystatechange = function()
                            {
                                if (http1.readyState === XMLHttpRequest.DONE && http1.status === 200)
                                {
                                    var raw = JSON.parse(http1.responseText);

                                    imageid[i] = raw.imageid;
                                }
                            }
                            http1.send
                            (
                                "image=" + encodeURIComponent(btoa(image[i]))
                            );
                        }
                        
                        // post html
                        var http2 = new XMLHttpRequest();

                        http2.open("POST", hosturl + "insertsite", true);
                        http2.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        http2.onreadystatechange = function()
                        {
                            if (http2.readyState === XMLHttpRequest.DONE && http2.status === 200)
                            {
                                var raw = JSON.parse(http2.responseText);
                                
                                var siteid = raw.siteid;

                                var title = document.querySelector('input[name="title"]');
                                var address = document.querySelector('input[name="address"]');
                                var email = document.querySelector('input[name="email"]');
                                var body = document.querySelector('.searchbar > textarea');
                                var html = "";
                                var http5 = new XMLHttpRequest();
                                
                                http5.open("POST", hosturl + "generatesite", true);
                                http5.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                http5.onreadystatechange = function()
                                {
                                    if (http5.readyState === XMLHttpRequest.DONE && http5.status === 200)
                                    {
                                        html = http5.responseText;

                                        var http3 = new XMLHttpRequest();

                                        http3.open("POST", hosturl + "updatesite", true);
                                        http3.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                        http3.onreadystatechange = function()
                                        {
                                            if (http3.readyState === XMLHttpRequest.DONE && http3.status === 200)
                                            {
                                                // index
                                                var dtoe = document.querySelector('input[name="expiration"]');
                                                var http4 = new XMLHttpRequest();

                                                http4.open("POST", apiurl + "insert", true);
                                                http4.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                http4.onreadystatechange = function()
                                                {
                                                    if (http4.readyState === XMLHttpRequest.DONE && http4.status === 200)
                                                    {
                                                        location.href = hosturl + "getsite?siteid=" + siteid;
                                                    }
                                                }
                                                http4.send
                                                (
                                                    "address=" + encodeURIComponent(address.value)
                                                    + "&expiration=" + encodeURIComponent(dtoe.value)
                                                    + "&url=" + encodeURIComponent(hosturl + "getsite?siteid=" + siteid)
                                                );
                                            }
                                        }
                                        http3.send
                                        (
                                            "siteid=" + siteid
                                            + "&email=" + encodeURIComponent(email.value)
                                            + "&html=" + encodeURIComponent(html)
                                        );

                                    }
                                }
                                http5.send
                                (
                                    "siteid=" + siteid
                                    + "&imageid=" + encodeURIComponent(imageid.join(" "))
                                    + "&title=" + encodeURIComponent(title.value)
                                    + "&address=" + encodeURIComponent(address.value)
                                    + "&email=" + encodeURIComponent(email.value)
                                    + "&body=" + encodeURIComponent(body.value)
                                );

                            }
                        }
                        http2.send
                        (
                        );
                    }
                );
                
                return false;
            }
        </script>

        <form enctype="multipart/form-data" onsubmit="return submitPage()">
            <div class="searchbar">
                <input id="search1" type="text" name="email" placeholder="Email address">
                <input id="search2" type="text" name="address" placeholder="Address or place">
                <input id="search3" type="text" name="expiration" placeholder="Expiration (YYYY-MM-DD 00:00:00)">
                <input id="search4" type="text" name="title" placeholder="Title">
                <textarea id="message1" type="text" name="body" placeholder="Body" style="resize: none;"></textarea>
                <input class="button" type="file" onchange="previewFiles()" multiple><br>
                <div id="preview"></div>
                <button class="button">Submit</button>
             </div>
        </form>
  </body>
</html>