workspace(name = "kubecf")

load(":def.bzl", "project")

local_repository(
    name = "workspace",
    path = "rules/workspace",
)

local_repository(
    name = "external_binaries",
    path = "rules/external_binaries",
)

load("@external_binaries//:def.bzl", "external_binary")

[external_binary(
    name = name,
    config = config,
) for name, config in project.external_binaries.items()]

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

[http_archive(
    name = name,
    sha256 = config.sha256,
    urls = [u.format(version = config.version) for u in config.urls],
    strip_prefix = getattr(config, "strip_prefix", "").format(version = config.version),
    build_file_content = getattr(config, "build_file_content", None),
) for name, config in project.bazel_libs.items()]

[http_file(
    name = name,
    urls = [u.format(version = getattr(config, "version", "")) for u in config.urls],
    sha256 = config.sha256,
) for name, config in project.external_files.items()]

load("@rules_python//python:pip.bzl", "pip_repositories", "pip3_import")

pip_repositories()

pip3_import(
    name = "yamllint",
    requirements = "//dev/linters/yamllint:requirements.txt",
)

load("@yamllint//:requirements.bzl", "pip_install")

pip_install()

load("@rules_gomplate//:repositories.bzl", "gomplate_repositories")

gomplate_repositories()

load("@workspace//:def.bzl", "workspace_root")

workspace_root(
    name = "workspace_root",
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "dc97fccceacd4c6be14e800b2a00693d5e8d07f69ee187babfd04a80a9f8e250",
    strip_prefix = "rules_docker-0.14.1",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.1/rules_docker-v0.14.1.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load(
    "@io_bazel_rules_docker//repositories:deps.bzl",
    container_deps = "deps",
)

container_deps()

load("//:image_repositories.bzl", "image_repositories")

image_repositories()
