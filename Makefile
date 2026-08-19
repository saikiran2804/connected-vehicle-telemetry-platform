SERVICES := telemetry-ingest alerts-processor

.PHONY: install lint test compose-up compose-down

install:
	@for svc in $(SERVICES); do \
		echo "==> installing $$svc"; \
		pip install -r services/$$svc/requirements.txt -r services/$$svc/requirements-dev.txt; \
	done

lint:
	ruff check services

test:
	@for svc in $(SERVICES); do \
		echo "==> testing $$svc"; \
		( cd services/$$svc && python -m pytest -q ); \
	done

compose-up:
	docker compose up --build

compose-down:
	docker compose down -v
