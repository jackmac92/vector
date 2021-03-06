---
last_modified_on: "2020-03-31"
$schema: "/.meta/.schemas/guides.json"
title: Deploying Vector
description: How to deploy Vector to your target environment
series_position: 3
author_github: https://github.com/binarylogic
tags: ["type: tutorial", "domain: operations"]
---

import CodeExplanation from '@site/src/components/CodeExplanation';
import ConfigExample from '@site/src/components/ConfigExample';
import DaemonDiagram from '@site/src/components/DaemonDiagram';
import InstallationCommand from '@site/src/components/InstallationCommand';
import ServiceDiagram from '@site/src/components/ServiceDiagram';
import SidecarDiagram from '@site/src/components/SidecarDiagram';
import Steps from '@site/src/components/Steps';
import SVG from 'react-inlinesvg';
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

What good is Vector if you can't deploy it?! Fortunately, deploying Vector is
easy. Vector is written in [Rust][urls.rust] and compiles to a single static
binary. Meaning there are no dependencies or runtime, making the actual act of
installing Vector as easy as copying the binary to your target host. Beyond
that, you'll want to think strategically about _how_ you deploy Vector. This is
where the magic lies and this is precisely what this guide will touch on.

<!--
     THIS FILE IS AUTOGENERATED!

     To make changes please edit the template located at:

     website/guides/getting-started/deploying.md.erb
-->

## Basic Concepts

Before we get into the [installation tutorial](#tutorial), let's touch on some
basic Vector deployment concepts. We've had the fortunate opportunity of working
with many different companies deploying Vector, and all of their approaches
can be broken down into two basic concepts: [strategies](#strategies) and
[topologies](#topologies).

### Strategies

Strategies refer to data collection on a _single_ host. It's the very first
thing you'll think about when deploying Vector. For example, are you
operationally proficient and comfortable installing Vector directly on each of
your host? Or are you an app developer only concerned with data collection for
your service? Each context requires a different deployment strategy! To solve
this, we've broken down deploying Vector into three basic strategies. These
are best explained with diagrams, and [covered in more detail][docs.strategies]
in our docs.

<Tabs
  centered={true}
  className="rounded"
  defaultValue="daemon"
  values={[{"label":"Daemon","value":"daemon"},{"label":"Service","value":"service"},{"label":"Sidecar","value":"sidecar"}]}>
<TabItem value="daemon">

<DaemonDiagram
  platformName={null}
  sourceName={null}
  sinkName={null} />

</TabItem>
<TabItem value="service">

<ServiceDiagram
  platformName={null}
  sourceName={null}
  sinkName={null} />

</TabItem>
<TabItem value="sidecar">

<SidecarDiagram
  platformName={null}
  sourceName={null}
  sinkName={null} />

</TabItem>
</Tabs>

### Topologies

Topologies refer to the high-level network that your Vector instances create
to get data from A to B -- the zoomed out perspective. This, again, is largely
dependent on your environment and downstream storages. We've broken these
down into three basic examples. Use these as _guidelines_ to form your own
topology. These are best explained with diagrams, and [covered in more
detail][docs.topologies] in our docs.

<Tabs
  centered={true}
  className="rounded"
  defaultValue="distributed"
  values={[
    {value: "distributed", label: "Distributed"},
    {value: "centralized", label: "Centralized"},
    {value: "stream-based", label: "Stream-based"},
  ]}>
<TabItem value="distributed">
<SVG src="/img/topologies-distributed.svg" />
</TabItem>
<TabItem value="centralized">
<SVG src="/img/topologies-centralized.svg" />
</TabItem>
<TabItem value="stream-based">
<SVG src="/img/topologies-stream-based.svg" />
</TabItem>
</Tabs>

## Tutorial

Now it's time to get to business! This tutorial will walk through the simple
act of deploying Vector within your environment.

<Tabs
  block={true}
  defaultValue="daemon"
  values={[{"label":"As a Daemon","value":"daemon"}]}>
<TabItem value="daemon">


<Tabs
  centered={false}
  className={null}
  defaultValue={"dpkg"}
  placeholder="Please choose an installation method..."
  select={true}
  size={"lg"}
  values={[{"group":"Package managers","label":"DPKG","value":"dpkg"},{"group":"Platforms","label":"Docker CLI","value":"docker-cli"},{"group":"Platforms","label":"Docker Compose","value":"docker-compose"},{"group":"Package managers","label":"Homebrew","value":"homebrew"},{"group":"Package managers","label":"MSI","value":"msi"},{"group":"Package managers","label":"Nix","value":"nix"},{"group":"Package managers","label":"RPM","value":"rpm"},{"group":"Nones","label":"Vector CLI","value":"vector-cli"}]}>
<TabItem value="dpkg">

<Tabs
  centered={true}
  className="rounded"
  defaultValue="x86_64"
  values={[{"label":"x86_64","value":"x86_64"},{"label":"ARM64","value":"arm64"},{"label":"ARMv7","value":"armv7"}]}>

<TabItem value="x86_64">
<Steps headingDepth={3}>
<ol>
<li>

### Download the Vector `.deb` package

```bash
curl --proto '=https' --tlsv1.2 -O https://packages.timber.io/vector/0.8.X/vector-amd64.deb
```

[Looking for a different version?][docs.package_managers.dpkg#versions]

</li>
<li>

### Install the downloaded package

```bash
sudo dpkg -i vector-amd64.deb
```

</li>
<li>

### Configure Vector

<ConfigExample
  format="toml"
  path="/etc/vector/vector.toml"
  sourceName={"docker"}
  sinkName={null} />

</li>
<li>

### Start Vector

```bash
sudo systemctl start vector
```

</li>
</ol>
</Steps>
</TabItem>
<TabItem value="arm64">
<Steps headingDepth={3}>
<ol>
<li>

### Download the Vector `.deb` package

```bash
curl --proto '=https' --tlsv1.2 -O https://packages.timber.io/vector/0.8.X/vector-arm64.deb
```

[Looking for a different version?][docs.package_managers.dpkg#versions]

</li>
<li>

### Install the downloaded package

```bash
sudo dpkg -i vector-arm64.deb
```

</li>
<li>

### Configure Vector

<ConfigExample
  format="toml"
  path="/etc/vector/vector.toml"
  sourceName={"docker"}
  sinkName={null} />

</li>
<li>

### Start Vector

```bash
sudo systemctl start vector
```

</li>
</ol>
</Steps>
</TabItem>
<TabItem value="armv7">
<Steps headingDepth={3}>
<ol>
<li>

### Download the Vector `.deb` package

```bash
curl --proto '=https' --tlsv1.2 -O https://packages.timber.io/vector/0.8.X/vector-armhf.deb
```

[Looking for a different version?][docs.package_managers.dpkg#versions]

</li>
<li>

### Install the downloaded package

```bash
sudo dpkg -i vector-armhf.deb
```

</li>
<li>

### Configure Vector

<ConfigExample
  format="toml"
  path="/etc/vector/vector.toml"
  sourceName={"docker"}
  sinkName={null} />

</li>
<li>

### Start Vector

```bash
sudo systemctl start vector
```

</li>
</ol>
</Steps>
</TabItem>
</Tabs>

</TabItem>
<TabItem value="docker-cli">

<Steps headingDepth={3}>
<ol>
<li>

### Configure Vector

<ConfigExample
  format="toml"
  path="vector.toml"
  sourceName={"docker"}
  sinkName={null} />

</li>
<li>

### Start the Vector container

```bash
docker run \
  -v $PWD/vector.toml:/etc/vector/vector.toml:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  timberio/vector:latest-alpine
```

<CodeExplanation>

* The `-v $PWD/vector.to...` flag passes your custom configuration to Vector.
* The `-v /var/run/docke...` flag ensures that Vector has access to the Docker API.
* The `timberio/vector:latest-alpine` is the default image we've chosen, you are welcome to use [other image variants][docs.platforms.docker#variants].

</CodeExplanation>

That's it! Simple and to the point. Hit `ctrl+c` to exit.

</li>
</ol>
</Steps>

</TabItem>
<TabItem value="docker-compose">

compose!

</TabItem>
<TabItem value="homebrew">

<Steps headingDepth={3}>
<ol>
<li>

### Add the Timber tap and install `vector`

```bash
brew tap timberio/brew && brew install vector
```

[Looking for a specific version?][docs.package_managers.homebrew]

</li>
<li>

### Configure Vector

<ConfigExample
  format="toml"
  path="/etc/vector/vector.toml"
  sourceName={"docker"}
  sinkName={null} />

</li>
<li>

### Start Vector

```bash
brew services start vector
```

</li>
</ol>
</Steps>

</TabItem>
<TabItem value="msi">

<Steps headingDepth={3}>
<Tabs
  centered={true}
  className="rounded"
  defaultValue="x86_64"
  values={[{"label":"x86_64","value":"x86_64"}]}>

<TabItem value="x86_64">

1.  ### Download the Vector `.msi` file

    ```bat
    powershell Invoke-WebRequest https://packages.timber.io/vector/0.8.X/vector-x64.msi -OutFile vector-x64.msi
    ```

    [Looking for a specific version?][docs.package_managers.msi#versions]

2.  ### Install the Vector `.msi` package using `msiexec` command

    ```bat
    msiexec /i vector-x64.msi /quiet
    ```

3.  ### Navigate to the Vector directory

    ```bat
    cd "C:\Program Files\Vector"
    ```

4.  ### Configure Vector

    <ConfigExample
      format="toml"
      path="config\vector.toml"
      sourceName={"docker"}
      sinkName={null} />

5.  ### Start Vector

    ```bat
    .\bin\vector --config config\vector.toml
    ```

</TabItem>
</Tabs>
</Steps>

</TabItem>
<TabItem value="nix">

<Steps headingDepth={3}>

1.  ### Install Vector

    ```bash
    nix-env --file https://github.com/NixOS/nixpkgs/archive/master.tar.gz --install --attr vector
    ```

    <CodeExplanation>

    * The `--file` flag ensures that you're installing the latest stable version
      of Vector (0.8.2).
    * The `--attr` improves installation speed.

    </CodeExplanation>

    [Looking for a specific version?][docs.package_managers.nix#versions]

2.  ### Configure Vector

    <ConfigExample
      format="toml"
      path="/etc/vector/vector.toml"
      sourceName={"docker"}
      sinkName={null} />

3.  ### Start Vector

    ```bash
    vector --config /etc/vector/vector.toml
    ```

    <CodeExplanation>

    * `vector` is placed in your `$PATH`.
    * You must create a [Vector configuration file][docs.configuration] to
      successfully start Vector.

    </CodeExplanation>

</Steps>

</TabItem>
<TabItem value="rpm">

<Steps headingDepth={3}>
<Tabs
  centered={true}
  className="rounded"
  defaultValue="arm64"
  values={[{"label":"ARM64","value":"arm64"},{"label":"ARMv7","value":"armv7"},{"label":"x86_64","value":"x86_64"}]}>

<TabItem value="arm64">

1.  ### Download the Vector `.rpm` file

    ```bash
    curl -O https://packages.timber.io/vector/0.8.X/vector-aarch64.rpm
    ```

    [Looking for a specific version?][docs.package_managers.rpm#versions]

2.  ### Install the Vector `.rpm` package directly

    ```bash
    sudo rpm -i vector-aarch64.rpm
    ```

3.  ### Configure Vector

    <ConfigExample
      format="toml"
      path="/etc/vector/vector.toml"
      sourceName={"docker"}
      sinkName={null} />

4.  ### Start Vector

    ```bash
    sudo systemctl start vector
    ```

</TabItem>
<TabItem value="armv7">

1.  ### Download the Vector `.rpm` file

    ```bash
    curl -O https://packages.timber.io/vector/0.8.X/vector-armv7hl.rpm
    ```

    [Looking for a specific version?][docs.package_managers.rpm#versions]

2.  ### Install the Vector `.rpm` package directly

    ```bash
    sudo rpm -i vector-armv7hl.rpm
    ```

3.  ### Configure Vector

    <ConfigExample
      format="toml"
      path="/etc/vector/vector.toml"
      sourceName={"docker"}
      sinkName={null} />

4.  ### Start Vector

    ```bash
    sudo systemctl start vector
    ```

</TabItem>
<TabItem value="x86_64">

1.  ### Download the Vector `.rpm` file

    ```bash
    curl -O https://packages.timber.io/vector/0.8.X/vector-x86_64.rpm
    ```

    [Looking for a specific version?][docs.package_managers.rpm#versions]

2.  ### Install the Vector `.rpm` package directly

    ```bash
    sudo rpm -i vector-x86_64.rpm
    ```

3.  ### Configure Vector

    <ConfigExample
      format="toml"
      path="/etc/vector/vector.toml"
      sourceName={"docker"}
      sinkName={null} />

4.  ### Start Vector

    ```bash
    sudo systemctl start vector
    ```

</TabItem>
</Tabs>
</Steps>

</TabItem>
<TabItem value="vector-cli">

<Steps headingDepth={3}>
<ol>
<li>

### Install Vector

<InstallationCommand />

</li>
<li>

### Configure Vector

<ConfigExample
  format="toml"
  path="vector.toml"
  sourceName={"docker"}
  sinkName={null} />

</li>
<li>

### Start Vector

```bash
vector --config vector.toml
```

That's it! Simple and to the point. Hit `ctrl+c` to exit.

</li>
</ol>
</Steps>

</TabItem>
</Tabs>
</TabItem>
</Tabs>


[docs.configuration]: /docs/setup/configuration/
[docs.package_managers.dpkg#versions]: /docs/setup/installation/package-managers/dpkg/#versions
[docs.package_managers.homebrew]: /docs/setup/installation/package-managers/homebrew/
[docs.package_managers.msi#versions]: /docs/setup/installation/package-managers/msi/#versions
[docs.package_managers.nix#versions]: /docs/setup/installation/package-managers/nix/#versions
[docs.package_managers.rpm#versions]: /docs/setup/installation/package-managers/rpm/#versions
[docs.platforms.docker#variants]: /docs/setup/installation/platforms/docker/#variants
[docs.strategies]: /docs/setup/deployment/strategies/
[docs.topologies]: /docs/setup/deployment/topologies/
[urls.rust]: https://www.rust-lang.org/
