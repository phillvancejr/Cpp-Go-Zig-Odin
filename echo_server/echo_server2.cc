#include <asio.hpp>
#include <stdio.h>
#include <system_error>
#include <string>

int main() {
    asio::io_context io;
    asio::ip::tcp::acceptor server(io, asio::ip::tcp::endpoint(asio::ip::tcp::v4(), 8000));
    puts("Listening on port 8000");

    asio::ip::tcp::socket client(io);
    server.accept(client);
    puts("client connected!");

    std::error_code e;
    asio::write(client, asio::buffer("Welcome to Asio Chat!\n"), e);

    if (e) { printf("greet error %s\n", e.message().c_str()); return -1; }

    while (true) {
        asio::streambuf buf;
        asio::read_until(client, buf, "\n", e);

        if (e == asio::error::eof) { 
            puts("client disconnected");
            break;
        } else if (e) {
            printf("read error %s\n", e.message().c_str()); 
            return -1; 
        }

        std::string msg = asio::buffer_cast<const char*>(buf.data());
        if (msg.find("bye") != std::string::npos) {
            puts("its so hard to say goodbye!");
            asio::write(client, asio::buffer("good bye!\n"), e);
            client.shutdown(asio::ip::tcp::socket::shutdown_both, e);
            client.close(e);
            break;
        }

        auto reply = "echo: " + msg;
        asio::write(client, asio::buffer(reply), e);

        if (e) { printf("write error %s\n", e.message().c_str()); return -1; }

        printf("%s", msg.data());
    }

    puts("shutting down");
}