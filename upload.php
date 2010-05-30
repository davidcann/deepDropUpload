<?

// saving uploads is disabled for demo purposes
exit();

$headers = getallheaders();
$file = new stdClass;
$file->name = basename($headers['X-File-Name']);
$file->size = $headers['X-File-Size'];
$file->content = file_get_contents("php://input");

// if everything is ok, save the file somewhere
$storage = "/uploads/";
if (file_exists($storage)) {
	$extension = end(explode(".", $file->name));
	$unique = rand(1000000000,9999999999) .".". $extension;
	while (file_exists($storage . $unique)) {
		$unique = rand(1000000000,9999999999) .".". $extension;
	}
	$path = $storage . $unique;

	$handle = fopen($path, 'w');
	fwrite($handle, $file->content);
	fclose($handle);
}

?>