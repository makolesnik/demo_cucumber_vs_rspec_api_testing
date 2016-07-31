Feature:

  Background:
    Given a "REST" API definition at "BASE_URI"
    And security query param "key" equals "API_KEY"

  Scenario Outline:
    Given endpoint "/getLangs" and method "get"
    And request query param "ui" equals "<language_code>"
    When the request is executed
    Then response status is "200"
    And response body has attributes
      | attribute |
      | dirs      |
      | langs     |

    Examples:
      | language_code |
      | en            |
      | ru            |
      | ua            |
      | sp            |
      | ge            |
      | fr            |



