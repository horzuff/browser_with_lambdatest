To start playwright server in docker run

'docker run -p 3000:3000 --rm --init -it --workdir /home/pwuser --user pwuser mcr.microsoft.com/playwright:v1.56.1-noble /bin/sh -c "npx -y playwright@1.56.1 run-server --port 3000 --host 0.0.0.0"'

then the websocket endpoint address would be ws://127.0.0.1:3000/

more info: https://playwright.dev/docs/docker