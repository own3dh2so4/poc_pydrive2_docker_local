FROM python:3.10-slim as base

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1


FROM base AS python-deps

# Install pipenv and compilation dependencies
RUN pip install --no-cache-dir pipenv==2022.1.8

# Install python dependencies in /.venv
COPY Pipfile /
COPY Pipfile.lock /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN pipenv lock -r | pip install --no-cache-dir -r /dev/stdin --target /python_deps


FROM python:3.10-slim-bullseye

EXPOSE 8000

WORKDIR /app

# Copy virtual env from python-deps stage
COPY --from=python-deps /python_deps/. /usr/local/lib/python3.10/site-packages/.


# Copy function code
COPY client_secrets.json client_secrets.json
COPY main.py main.py


CMD ["python", "main.py"]