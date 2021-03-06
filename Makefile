#!/usr/bin/make -f

VERSION      := $(shell tagit -p --dry-run)
VERSION_FILE := smartystreets_python_sdk_version/__init__.py

clean:
	rm -rf dist/ MANIFEST
	git checkout "$(VERSION_FILE)"

test:
	python -m unittest discover -p *_test.py

dependencies:
	pip install -r requirements.txt

package: clean dependencies test
	echo "__version__=\"$(VERSION)\"" >> "$(VERSION_FILE)" \
		&& python setup.py sdist \
		&& git checkout "$(VERSION_FILE)"

publish: package
	twine upload --repository-url "https://test.pypi.org/legacy/" dist/*
	twine upload dist/*

release: publish
	tagit -p && git push origin --tags

.PHONY: clean test dependencies package publish release
