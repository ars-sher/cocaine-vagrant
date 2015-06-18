from cocaine.futures import chain
from cocaine.services import Service

from tornado.ioloop import IOLoop

# Alias for more readability.
asynchronous = chain.source

if __name__ == '__main__':
    io_loop = IOLoop.current()
    service = Service('Echo')

    @asynchronous
    def invoke(message):
        result = yield service.enqueue('ping', message)
        print(result)

    invoke('Hello World!')
    invoke('Hello again!')
    invoke('What the fuck')
    io_loop.start()
