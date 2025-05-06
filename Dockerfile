# syntax=docker.io/docker/dockerfile:1.7-labs

FROM --platform=linux/amd64 python:3.12-slim@sha256:aaa3f8cb64dd64e5f8cb6e58346bdcfa410a108324b0f28f1a7cc5964355b211 AS production

# Copy uv from the official distroless uv image
COPY --from=ghcr.io/astral-sh/uv:0.7.2@sha256:3b898ca84fbe7628c5adcd836c1de78a0f1ded68344d019af8478d4358417399 /uv /bin/uv

ENV PATH="/code/.venv/bin:$PATH" \
    UV_PYTHON_INSTALL_DIR=/usr/share/uv/python

WORKDIR /code

COPY ./pyproject.toml ./uv.lock* ./

RUN uv sync --locked --no-install-workspace --compile-bytecode --no-group dev

COPY --parents packages/  ./

RUN uv sync --compile-bytecode --all-packages --no-group dev && rm -r /usr/bin/uv

COPY . .

CMD ["python", "main.py"]
