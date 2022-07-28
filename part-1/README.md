
## Exercise 1.1: Getting started
```
$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS                          PORTS     NAMES
38779b7ae5f3   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute               80/tcp    sharp_haibt
8bd686deabbb   nginx     "/docker-entrypoint.…"   About a minute ago   Exited (0) About a minute ago             naughty_darwin
ae0abd98c3e2   nginx     "/docker-entrypoint.…"   About a minute ago   Exited (0) 3 seconds ago                  thirsty_banzai
```

---

## Exercise 1.2: Cleanup
```
$ docker rm $(docker ps -aq) && docker rmi $(docker images -q)
38779b7ae5f3
8bd686deabbb
ae0abd98c3e2
Untagged: nginx:latest
Untagged: nginx@sha256:1761fb5661e4d77e107427d8012ad3a5955007d997e0f4a3d41acc9ff20467c7
Deleted: sha256:670dcc86b69df89a9d5a9e1a7ae5b8f67619c1c74e19de8a35f57d6c06505fd4
Deleted: sha256:6464fa6ec55de5e162c3f978bafd00f63fd66829c5bedcb0b2af36c03230c10d
...

$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
$ docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
```

---

## Exercise 1.3: Secret message
```
$ docker run -d devopsdockeruh/simple-web-service:ubuntu
Unable to find image 'devopsdockeruh/simple-web-service:ubuntu' locally
ubuntu: Pulling from devopsdockeruh/simple-web-service
5d3b2c2d21bb: Pull complete 
3fc2062ea667: Pull complete 
75adf526d75b: Pull complete 
965d4bbb586a: Pull complete 
4f4fb700ef54: Pull complete 
Digest: sha256:d44e1dce398732e18c7c2bad9416a072f719af33498302b02929d4c112e88d2a
Status: Downloaded newer image for devopsdockeruh/simple-web-service:ubuntu
caefee60751d576dcc7446074cac1f849cfa85e929257b75e7c44ab2396afe91
$ docker exec -it caef sh
# tail -f ./text.log
2022-07-28 10:13:43 +0000 UTC
Secret message is: 'You can find the source code here: https://github.com/docker-hy'
```

---

## Exercise 1.4: Missing dependencies

```
$ docker run --rm -it ubuntu sh -c 'apt-get update -qq && apt-get install -yqq curl && echo "Input website:"; read website; echo "Searching.."; sleep 1; curl http://$website;'
...
(omitted apt-get output)
...
Input website:
helsinki.fi
Searching..
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>301 Moved Permanently</title>
</head><body>
<h1>Moved Permanently</h1>
<p>The document has moved <a href="https://www.helsinki.fi/">here</a>.</p>
</body></html>
```

---

## Exercise 1.5: Sizes of images

```
$ docker images
REPOSITORY                          TAG       IMAGE ID       CREATED         SIZE
devopsdockeruh/simple-web-service   ubuntu    4e3362e907d5   16 months ago   83MB
devopsdockeruh/simple-web-service   alpine    fd312adc88e0   16 months ago   15.7MB

$ docker run --rm -d devopsdockeruh/simple-web-service:alpine
4f45a7b4695f6e0e2480b685d24df7bc05e0da04228f7b5b21d9273527ad35c7
$ docker exec -it 4f45 sh
/usr/src/app # tail -f ./text.log
2022-07-28 10:47:24 +0000 UTC
2022-07-28 10:47:26 +0000 UTC
Secret message is: 'You can find the source code here: https://github.com/docker-hy'
```

---

## Exercise 1.6: Hello Docker Hub

The password is presented in the image readme on Dockerhub.

```
$ docker run -it devopsdockeruh/pull_exercise
Unable to find image 'devopsdockeruh/pull_exercise:latest' locally
latest: Pulling from devopsdockeruh/pull_exercise
8e402f1a9c57: Pull complete 
5e2195587d10: Pull complete 
6f595b2fc66d: Pull complete 
165f32bf4e94: Pull complete 
67c4f504c224: Pull complete 
Digest: sha256:7c0635934049afb9ca0481fb6a58b16100f990a0d62c8665b9cfb5c9ada8a99f
Status: Downloaded newer image for devopsdockeruh/pull_exercise:latest
Give me the password: basics
You found the correct password. Secret message is:
"This is the secret message"
```

---

## Exercise 1.7: Two line Dockerfile

Dockerfile
```
FROM devopsdockeruh/simple-web-service:alpine
CMD server
````

Commands
```
$ docker build . -t web-server
[+] Building 0.1s (5/5) FINISHED                                                                
 => [internal] load build definition from Dockerfile                                       0.0s
 => => transferring dockerfile: 99B                                                        0.0s
 => [internal] load .dockerignore                                                          0.0s
 => => transferring context: 2B                                                            0.0s
 => [internal] load metadata for docker.io/devopsdockeruh/simple-web-service:alpine        0.0s
 => [1/1] FROM docker.io/devopsdockeruh/simple-web-service:alpine                          0.0s
 => exporting to image                                                                     0.0s
 => => exporting layers                                                                    0.0s
 => => writing image sha256:978fbf315695ef5a3ec2e77ee411c4dcd9aa9b867fbc7ea3d26962545fda0  0.0s
 => => naming to docker.io/library/web-server                                              0.0s
$ docker run --rm web-server
[GIN-debug] [WARNING] Creating an Engine instance with the Logger and Recovery middleware already attached.

[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] GET    /*path                    --> server.Start.func1 (3 handlers)
[GIN-debug] Listening and serving HTTP on :8080                                  
```

---

## Exercise 1.8: Image for script

Dockerfile
```
FROM ubuntu:20.04
RUN apt-get -qq update && apt-get -yqq install curl
WORKDIR /app
COPY ./curler.sh .
RUN chmod 700 /app/curler.sh
CMD ["/usr/bin/sh", "/app/curler.sh"]
```

---

## Exercise 1.9: Volumes

```
$ touch text.log
$ docker run --rm -v "$(pwd)/text.log:/usr/src/app/text.log" devopsdockeruh/simple-web-service:alpine
Wrote text to /usr/src/app/text.log
Wrote text to /usr/src/app/text.log
Wrote text to /usr/src/app/text.log
Wrote text to /usr/src/app/text.log
^C

$ cat text.log

2022-07-28 11:36:03 +0000 UTC
2022-07-28 11:36:05 +0000 UTC
Secret message is: 'You can find the source code here: https://github.com/docker-hy'
2022-07-28 11:36:07 +0000 UTC
```

---

## Exercise 1.10: Ports open

```
$ docker run --rm -d -p 80:8080 devopsdockeruh/simple-web-service:alpine server
173663d36e436981aada055bdf4ab0df7db9e4a4cc04723e8c66357348239411
$ curl localhost:80
{"message":"You connected to the following path: /","path":"/"}% 
```

---

## Exercise 1.11: Spring

Dockerfile
```
FROM openjdk:8
WORKDIR /build
COPY spring-example-project/ /build/
RUN /build/mvnw package
CMD ["java", "-jar", "/build/target/docker-example-1.1.3.jar"]
```

Checking that app works with curl
```
$ curl localhost:8080
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">        <title>Spring</title>
        <meta charset="UTF-8" />

    </head>
    <body style="width: fit-content; padding-top: 3em; margin: auto;">
        <form action="/press" method="post">
            <button class="btn btn-info btn-outline-dark" type="submit">Press here</button>
        </form>
        <p style="width: fit-content; margin: auto;"></p>
    </body>
</html>
```

---

## Exercise 1.12: Hello, frontend!

Dockerfile
```
FROM node:alpine
WORKDIR /app
COPY example-frontend/ /app/
RUN npm install && npm install -g serve && npm update && npm run build
CMD ["serve", "-s", "-l", "5000", "build"]
EXPOSE 5000
```

Check that service works with curl

$ curl localhost:5000
```
<!doctype html><html lang="en"><head><meta charset="utf-8"/><meta name="viewport" content="width=device-width,initial-scale=1"/><meta name="theme-color" content="#000000"/><meta name="description" content="Frontend for docker course"/><link rel="manifest" href="/manifest.json"/><title>Docker frontend</title><link href="/static/css/main.eaa5d75e.chunk.css" rel="stylesheet"></head><body><noscript>You need to enable JavaScript to run this app.</noscript><div id="root"></div><script>!function(e){function r(r){for(var n,l,f=r[0],a=r[1],p=r[2],c=0,s=[];c<f.length;c++)l=f[c],Object.prototype.hasOwnProperty.call(o,l)&&o[l]&&s.push(o[l][0]),o[l]=0;for(n in a)Object.prototype.hasOwnProperty.call(a,n)&&(e[n]=a[n]);for(i&&i(r);s.length;)s.shift()();return u.push.apply(u,p||[]),t()}function t(){for(var e,r=0;r<u.length;r++){for(var t=u[r],n=!0,f=1;f<t.length;f++){var a=t[f];0!==o[a]&&(n=!1)}n&&(u.splice(r--,1),e=l(l.s=t[0]))}return e}var n={},o={1:0},u=[];function l(r){if(n[r])return n[r].exports;var t=n[r]={i:r,l:!1,exports:{}};return e[r].call(t.exports,t,t.exports,l),t.l=!0,t.exports}l.m=e,l.c=n,l.d=function(e,r,t){l.o(e,r)||Object.defineProperty(e,r,{enumerable:!0,get:t})},l.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},l.t=function(e,r){if(1&r&&(e=l(e)),8&r)return e;if(4&r&&"object"==typeof e&&e&&e.__esModule)return e;var t=Object.create(null);if(l.r(t),Object.defineProperty(t,"default",{enumerable:!0,value:e}),2&r&&"string"!=typeof e)for(var n in e)l.d(t,n,function(r){return e[r]}.bind(null,n));return t},l.n=function(e){var r=e&&e.__esModule?function(){return e.default}:function(){return e};return l.d(r,"a",r),r},l.o=function(e,r){return Object.prototype.hasOwnProperty.call(e,r)},l.p="/";var f=this["webpackJsonpexample-frontend"]=this["webpackJsonpexample-frontend"]||[],a=f.push.bind(f);f.push=r,f=f.slice();for(var p=0;p<f.length;p++)r(f[p]);var i=a;t()}([])</script><script src="/static/js/2.43ca3586.chunk.js"></script><script src="/static/js/main.d5ce08a2.chunk.js"></script></body></html>
```

---

