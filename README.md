#BackerJS

GPL Node.js-powered backup daemon. It communicates solely over HTTP via the Express server. It depends on Redis, and works on any Linux/Unix systems with the `zip` utility installed. No Windows, sorry.

Some reference (needs a bit o improvement):

###Concepts
This is daemon is both a slave and a master, in a slave-master system. It can compress and send given directories to other daemons. Each zip, or backup, is identified by its `key`, which is also its filename.

###Publicish API

* `get /download/:link` - Downloads a zip with the given generated key (made in `command/publicize`). After the download is complete, the link will no longer be valid.
* `post /status` - Lists the statuses, in JSON format by `key`, of all backups stored or gone through the server.

###Command API
All requests here require a `password` parameter, which is set in the config.js of the daemon. Additional parameters required for each command are shown below its entry.

* `post /command/size` - Generates the size of a folder, in kilobytes.
  * `path` - Path of the directory to size. If it does not exist, a 400 status code will be returned.
* `post /command/send` - Zips and sends a folder to another node.
  * `dest_host`, `dest_port`, `dest_password` - Destination host, port, and password (respectively) for the daemon to transfer to. If any of these are absent, a 400 error will be returned.
  * `key` - The `key` of the backup to be generated. If this is not present, a 400 error will be returned.
  * `path` - Path of the directory to send. If it does not exist, a 400 status code will be returned.
* `post /command/send/restore` - Sends an *existing* zip and restores it to a node.
  * `key` The `key` of the backup to restore. A 400 error will be returned if the given backup does not exist.
  * `path` - The destination path to restore to. If this is not given, a 400 error will be returned.
  * `dest_host`, `dest_port`, `dest_password` - Destination host, port, and password (respectively) for the daemon to transfer to. If any of these are absent, a 400 error will be returned.
* `post /command/remove` - Removes a zip by its key.
  * `key` - The key to remove. If the key is not given, a 400 error will be returned.
* `post /command/command/publicize` - Causes the link `/download/:link` to become a valid, one use link to download the given backup.
  * `key` - The `key` of the backup to restore. A 400 error will be returned if the given backup does not exist.
  * `link` - The `:link` to use. If this is not given, a 400 error will be returned.