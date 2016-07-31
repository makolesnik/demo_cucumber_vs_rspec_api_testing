Feature:

  Background:
    Given a "REST" API definition at "BASE_URI"
    And security query param "key" equals "API_KEY"

  Scenario Outline:
    Given endpoint "/translate" and method "get"
    And request query params
      | param  | value               |
      | text   | <text_sample>       |
      | lang   | <translate_to_code> |
      | format | <format>            |
    When the request is executed
    Then response body has attributes
      | attribute | value                    |
      | code      | 200                      |
      | lang      | <translate_from_to_code> |
      | text      | <translation>            |

    Examples:
      | text_sample  | translation      | translate_to_code | translate_from_to_code | format |
      | Hello World! | ["Всем Привет!"] | ru                | en-ru                  |        |
      | Hello World! | ["Всем Привет!"] | ru                | en-ru                  | plain  |
      | Hello World! | ["Всем Привет!"] | ru                | en-ru                  | html   |
      | Всем Привет! | ["Hello!"]       | en                | ru-en                  |        |
      | Всем Привет! | ["Hello!"]       | en                | ru-en                  | plain  |
      | Всем Привет! | ["Hello!"]       | en                | ru-en                  | html   |


  Scenario Outline:
    Given endpoint "/translate" and method "get"
    And request query params
      | param   | value               |
      | lang    | <translate_to_code> |
      | options | 1                   |
    And request query param "text" equals "<text_sample>"
    When the request is executed
    Then response body has attributes
      | attribute | value                      |
      | code      | 200                        |
      | lang      | <translate_from_to_code>   |
      | text      | <translation>              |
      | detected  | {"lang":"<detected_code>"} |

    Examples:
      | text_sample  | translation      | translate_to_code | translate_from_to_code | detected_code |
      | Hello World! | ["Всем Привет!"] | ru                | en-ru                  | en            |
      | Всем Привет! | ["Hello!"]       | en                | ru-en                  | ru            |


  Scenario Outline:
    Given endpoint "/translate" and method "post"
    And content type "form"
    And request query params
      | param   | value               |
      | lang    | <translate_to_code> |
      | options | 1                   |
    And request payload param "text" equals "<text_sample>"
    When the request is executed
    Then response body has attributes
      | attribute | value                      |
      | code      | 200                        |
      | lang      | <translate_from_to_code>   |
      | text      | <translation>              |
      | detected  | {"lang":"<detected_code>"} |

    Examples:
      | text_sample  | translation      | translate_to_code | translate_from_to_code | detected_code |
      | Всем Привет! | ["Hello!"]       | en                | ru-en                  | ru            |
      | Hello World! | ["Всем Привет!"] | ru                | en-ru                  | en            |
