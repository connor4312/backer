module.exports =
	host: '127.0.0.1'
	command_port: 9001
	http_port: 8080

	password: 'foopass'

	file_path: __dirname + '/../storage/' # Must end in a slash
	max_size: 1024 * 1024              # Max size (in MB) this node can take before denying new transfers

	redis_port: 6379
	redis_host: '127.0.0.1'
	redis_options: {}