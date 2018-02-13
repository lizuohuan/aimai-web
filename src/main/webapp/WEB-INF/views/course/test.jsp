<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html><head>
    <meta charset="utf-8">
    <title>摄像头调起测试</title>
    <style type="text/css">
        body { font-family: Helvetica, sans-serif; }
        h2, h3 { margin-top:0; }
        form { margin-top: 15px; }
        form > input { margin-right: 15px; }
        #results { float:right; margin:20px; padding:20px; border:1px solid; background:#ccc; }
    </style>
</head>

<body>
<div id="results">Your captured image will appear here...</div>
    <div id="my_camera"></div>
<script type="text/javascript" src="<%=request.getContextPath()%>/resources/webcamjs/webcam.min.js"></script>
<script>
    Webcam.set({
        width: 320,
        height: 240,
        image_format: 'jpeg',
        jpeg_quality: 90
    });
    Webcam.attach( '#my_camera' );
</script>
    <form>
        <input type=button value="Take Snapshot" onClick="take_snapshot()">
    </form>

    <!-- Code to handle taking the snapshot and displaying it locally -->
    <script language="JavaScript">
        function take_snapshot() {
            // take snapshot and get image data
            Webcam.snap( function(data_uri) {
                // display results in page
                document.getElementById('results').innerHTML =
                        '<h2>Here is your image:</h2>' +
                        '<img src="'+data_uri+'"/>';
            } );
        }
    </script>
</body>

</html>