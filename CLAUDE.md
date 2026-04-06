# Project Guidelines

## Project Overview

Twine is a Rails 8 app for managing organisations, social groups, and businesses. It is multi-tenant: each **Platform** is a separate organisation, and users belong to platforms via **Memberships** with roles (`member`, `admin`, `super_admin`).

## Reading and Improving These Guidelines

- Review these guidelines as needed to ensure consistency; do not block implementation work to write or present a plan unless explicitly requested by the user.
- If you're corrected on style, please modify the guidelines to prevent making the same mistake again
- If you're asked to do something that conflicts with these guidelines, please update the guidelines
- If you detect unnecessary, contradictory, or redundant information, please remove or improve it
- Less is more: Guidelines should be as short and to the point as possible
- If something is claimed to be in the guidelines but isn't, add it to the guidelines

## Process of Reviewing and Executing Tasks

1. Read the documentation properly
2. Plan (skip unless asked to present plan)
   - Make a minimal plan tailored to the chosen mode; keep it short and actionable.
3. Implement
   - Make the smallest viable change that follows our conventions.
   - If a change impacts security/privacy, update `.claude/knowledge/security.md` in the same PR.
4. Run tests and linting
   - **ALWAYS use `bin/run-tests`** to run tests. This script has a 5-minute timeout and reports runtime.
     - If tests exceed 5 minutes, the script will terminate and notify you. Stop your current task and notify the user.
   - During development, run only non-system tests for faster feedback:
     - `bin/run-tests` (default: runs non-system tests)
   - To run specific test files or the entire suite:
     - `bin/run-tests test/path/to/specific_test.rb`
     - `bin/run-tests` (entire non-system test suite)
   - Only when asked to work on system tests as part of task, run entire test suite:
     - `bin/run-tests test/`
   - Run RuboCop: `bundle exec rubocop`.
5. Repeat 3 and 4 until green
   - Iterate on implementation and re-run tests/linting until both pass.
   - For UI changes, use the Playwright Node API (headless) to interact with and verify the local server — take screenshots, click buttons, fill forms, and confirm things work in practice. Run scripts from `/tmp/pw_test/` where `playwright` is installed (`node /tmp/pw_test/your_script.js`). Use `chromium.launch()` (headless by default). Inject auth via `bin/dev-session` as a signed cookie.
6. Commit and push
   - When working inside Conductor on a non-main branch: automatically commit and push after tests and linting pass, without waiting to be asked.
   - If test coverage was reduced (e.g. scenarios removed or assertions weakened), note it explicitly in the PR description.

## Error Handling

- We don't try to hide errors. Instead, we raise errors when something unexpected happens, so they are surfaced to our error tracker.
  - Example: raising an error in the `else` clause of a `case`-statement can help detect underlying data quality issues:
    ```ruby
    case price_type
    when "subscription"
      ...
    else
      raise "Unknown price_type: #{price_type}"
    end
    ```
- We don't use `Rails.logger.error` in error-handling, since we rarely monitor logs directly
- When using `rescue`, always specify the type of error being rescued (don't rescue `StandardError`)

## Negative Space Programming

- We prefer **immediate crashes** over attempting to handle unexpected system states.
- A hard crash is far safer than continuing with corrupted data or unspotted errors.
- **Raise early and often:** Use `raise` statements to surface unexpected user or system behavior immediately.
- **Avoid fallbacks:** Do not attempt to make the system deal with unexpected behavior "elegantly" (e.g., defaulting to `0` or `nil`, or swallowing exceptions).
- If the code reaches a state that shouldn't be possible, it should crash, so the issue is surfaced and can be easily fixed.

## Rails Conventions

- **RESTful Design:** Controllers must strictly follow REST conventions.
- Only use the seven standard actions: `index`, `show`, `new`, `create`, `edit`, `update`, `destroy`.
- Instead of adding a method called `export` to OrdersController, make an `Orders::ExportsController` with a `create` action
- **ActiveRecord over raw SQL:** Always prefer ActiveRecord query methods and scopes over raw SQL. Only use raw SQL when the query is not practically achievable with ActiveRecord.

## Code Style & Formatting

- The project uses Rubocop. Please adhere to the `rubocop.yml` file.
- Otherwise, make sure the style is consistent with the rest of the project.
- Use nested module/class definitions (`module ModuleName\n  class ClassName`) instead of compact style (`ModuleName::ClassName`).

### Variable Names

- Use explicit, descriptive variable names and avoid abbreviations.
  - Example: In view templates, use `form` instead of `f` for form builder variables: `form_with do |form|` rather than `form_with do |f|`.
  - This applies to all contexts: prefer `user` over `u`, `order` over `o`, `customer_account` over `account`, etc.
- **Avoid single-use variables:** Don't create intermediate variables that are only used once in the immediately following line, unless they significantly improve readability.
  - **When acceptable:** Create intermediate variables when they're used multiple times, represent a complex calculation, or add significant clarity.

### Code Comments

- We generally use as little code comments as possible, and try to rely on the code to explain itself
- Do not add obvious or redundant comments that restate what the code already makes clear.
- Only add comments to explain code that is genuinely hard to understand, encodes non-obvious business rules, or documents external API quirks/workarounds.
- Don't use code comments to explain changes you've made (i.e. "Replaced old method with new method"). Add that as a comment to the PR instead.

### Meta-programming

**Prohibited:** Do not use meta-programming techniques such as `send`, `public_send`, `__send__`, `try`, `define_method`, `method_missing`, `class_eval`, `instance_eval`, `respond_to?`, or dynamic method calls.

**Why:** Meta-programming makes code harder to understand, debug, and maintain. It obscures control flow, breaks IDE tooling, makes it difficult to trace where methods are defined, and can cause runtime errors that would otherwise be caught at load time.

**Instead:** Use explicit case statements, if/elsif chains, or hash lookups with explicit method calls.

### Models

- **Validations and callbacks**: Only add model validations and callbacks when the behavior is intrinsic to the model.
- **Scopes:** Don't create custom scopes for simple queries. Use ActiveRecord query methods directly.
  - **Preferred:** `Product.order(:name)`
  - **Avoid:** Creating a scope like `scope :ordered_by_name, -> { order(:name) }`
- **Separation of concerns:** Models should not contain view-specific logic. Keep HTML generation, CSS classes, and formatting in helpers.

### Controllers

- **Instance Variables:** Most controller actions should only have 1 instance variable, and there should rarely be more than 2.
  - Use helpers for formatting/transformation logic
  - Access related data through associations (e.g., `@order.customer` in views instead of separate `@customer` variable)

### Service Objects

- Service objects should have a single exposed call method and no `attr_reader` definitions
- When the `call` method needs to return multiple values, return a plain hash (e.g. `{ success: true, assignments: [...] }`). Do not use Struct or custom result classes.

### HTML and ERB

- **Keep views logic-free:** Data preparation, conditional calculations, and business logic belong in models or helpers, not views. Any computation beyond a trivial conditional should live in a named helper or model method.
- **No variable assignments in views:** Do not assign local variables in ERB templates (e.g. `<% foo = ... %>`). Use model methods or helpers directly inline instead.
- Use built-in Rails helpers instead of raw HTML as much as possible
  - For example, use `form.label` helper instead of raw `<label>` tags
- **Partials:** All partials should use strict locals to explicitly declare their expected local variables
- **No ERB comments:** Do not use ERB comments (`<%# ... %>`) in views. If a section needs explanation, the code should be self-explanatory or use HTML comments sparingly.

### Javascript

- We use Stimulus to write Javascript when Turbo is not sufficient
- We never add `<script>` tags to views
- We use https://betterstimulus.com/ for style principles

### HTML & CSS

- The project uses [Tailwind](https://tailwindcss.com/) and the [daisyUI](https://daisyui.com/) library
- We prefer using daisyUI's classes over inlining Tailwind classes
- We avoid using the HTML style tag unless necessary

## Testing

- We use Minitest for testing.
- **ALWAYS use `bin/run-tests`** to run tests.

### Test Styles

- **System Tests:** Names should start with the role and explain at a high level what is being tested (e.g., `user can log in and view their dashboard`).
- **Other Tests (Controller, Job, etc.):** Test names should have the method name first: `#index succeeds` or `#show is only accessible to admins`.
- Don't make more than three tests for a single method unless explicitly asked
- **Use fixtures directly:** Don't assign fixtures to variables unless necessary.
  - **Preferred:** `get admin_order_path(orders(:sample_order))` directly
  - **Avoid:** `order = orders(:sample_order)` followed by `get admin_order_path(order)`
- Use `assert_difference -> {Order.count}` instead of `assert_difference 'Order.count'`

### Test Data

- We use fixtures for test data.
- Fixtures should tell a story about the data and have descriptive names
- Use fixtures sparingly: only a few fixtures for each model
- **Always prefer using existing fixtures** over creating new ones
- **Prefer modifying existing fixtures** using `update!` rather than creating new records
- When testing edge cases, create test data inline rather than adding fixtures

### Controller Tests

- We use ActionDispatch::IntegrationTest to test controllers
- All controller actions should have at least one test for the happy path named `"##{method name} succeeds"`
- The happy path test should have realistic test data that aims to provoke an N+1
- Avoid `assert_queries_count` when possible
- Use `assert_redirected_to` with the specific path instead of `assert_response :redirect`
- Use `assigns(:model_name)` to retrieve objects created/modified by controller actions instead of `Model.last`

### Job Tests

- Every job should have at least one test of the happy path, named `"#perform succeeds"`

## Configuration

### Secrets

- The project uses dotenv for environment variables, not Rails credentials
