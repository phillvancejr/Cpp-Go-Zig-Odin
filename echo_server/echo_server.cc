#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <string>
using namespace std::string_literals;
const int port = 8000;

int main() {
    auto server = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in server_addr;
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    server_addr.sin_addr.s_addr = INADDR_ANY;

    bind(server, (sockaddr*)&server_addr, sizeof(server_addr));
    puts("listening on port 8000");
    listen(server, 1);

    auto client = accept(server, nullptr, nullptr);

    if ( client == -1) {
        puts("accept error!");
        return 1;
    }
    puts("client connected!");
    auto welcome = "Welcome!\n"s;
    send(client, welcome.data(), welcome.size(), 0);


    while (true) {
        std::string msg;
        msg.reserve(128);
        // char buf[128]{0};
        // auto len = recv(client, buf, sizeof buf, 0);
        auto len = recv(client, msg.data(), msg.capacity(), 0);

        // msg += buf;
        if (msg.find("bye") != std::string::npos) {
            puts("saying goodbye!");
            auto bye = "Good bye!\n"s;
            send(client, bye.data(), bye.size(), 0);
            close(client);
            break;
        }
        if (len) {
            // printf("received: %s", buf);
            printf("received: %s", msg.data());
            // memset(buf,0,sizeof(buf));
            msg = "echo: " + msg + "\n";
            send(client, msg.data(), msg.size(), 0);
        } else {
            close(client);
            break;
        }
    }
    puts("shutting down");
    close(server);

}