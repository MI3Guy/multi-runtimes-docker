FROM debian:stretch-20190122-slim

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		wget xz-utils libc6 libgcc1 libgssapi-krb5-2 libicu57 libssl1.0.2 libstdc++6 zlib1g \
                ca-certificates apt-transport-https dirmngr gnupg python sudo build-essential

RUN mkdir runtimes

# Install OpenJDK
RUN cd runtimes && \
	wget -q https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz && \
	tar xf openjdk-11.0.2_linux-x64_bin.tar.gz && \
	rm openjdk-11.0.2_linux-x64_bin.tar.gz

ENV PATH "/runtimes/jdk-11.0.2/bin:${PATH}"

# Install SBT
RUN cd runtimes && \
	wget -q https://piccolo.link/sbt-1.2.8.tgz && \
	tar xf sbt-1.2.8.tgz && \
	rm sbt-1.2.8.tgz

ENV PATH "/runtimes/sbt/bin:${PATH}"

# Install .NET SDK
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
RUN cd runtimes && \
	wget -q https://dot.net/v1/dotnet-install.sh && \
	mkdir dotnet-sdk && \
	bash dotnet-install.sh --install-dir dotnet-sdk --version 2.2.103 && \
	rm dotnet-install.sh
	
ENV PATH "/runtimes/dotnet-sdk:${PATH}"

RUN dotnet help

# Install Mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb https://download.mono-project.com/repo/debian stable-stretch/snapshots/5.18.0 main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt-get update && apt-get install -y --no-install-recommends mono-devel fsharp msbuild ca-certificates-mono
ENV FrameworkPathOverride /usr/lib/mono/4.5/

# Install Node
RUN cd runtimes && \
	wget https://nodejs.org/dist/v11.8.0/node-v11.8.0-linux-x64.tar.xz && \
	tar xf node-v11.8.0-linux-x64.tar.xz && \
	rm node-v11.8.0-linux-x64.tar.xz

ENV PATH "/runtimes/node-v11.8.0-linux-x64/bin:${PATH}"


# User
RUN groupadd --gid 1000 rtuser && useradd --uid 1000 --gid rtuser --create-home rtuser
