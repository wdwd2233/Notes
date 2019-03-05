#include <uWS/uWS.h>
#include <thread>
#include <chrono>
#include <iostream>
using namespace uWS;

int main()
{
	Hub h;
	std::string response = "Hello!";

	h.onMessage([](WebSocket<SERVER> *ws, char *message, size_t length, OpCode opCode) {
		std::cout << "receive a websocket message from" << ws->getAddress().address << "-" << ws->getAddress().port << std::endl;
		std::string res = "hello";
		ws->send(res.c_str(), res.length(), opCode);
	});

	h.onHttpRequest([&](HttpResponse *res, HttpRequest req, char *data, size_t length,
		size_t remainingBytes) {
		res->end(response.data(), response.length());
	});

	if (h.listen(1234)) {
		h.run();
	}
}