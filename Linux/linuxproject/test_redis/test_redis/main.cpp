#include <hiredis/hiredis.h>
#include <stdio.h>
#include <string>

int main(void) {
	std::string ip = "127.0.0.1";
	int port = 6379;

	redisContext *context;
	redisReply *reply;

	context = redisConnect(ip.c_str(), port);
	if (context->err) {
		printf("Error connecting to redis\n");
		return -1;
	}

	reply = (redisReply*)redisCommand(context, "SET %s %s", "foo", "bar");
	if (!reply || context->err) {
		printf("Error setting key\n");
		return -1;
	}
	freeReplyObject(reply);

	reply = (redisReply*)redisCommand(context, "GET %s", "foo");
	if (!reply || context->err) {
		printf("Error gettihng key\n");
		return -1;
	}
	printf("Key foo = '%s'\n", reply->str);
	freeReplyObject(reply);

	redisFree(context);
	return 1;
}