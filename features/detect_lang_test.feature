Feature:

  Background:
    Given a "REST" API definition at "BASE_URI"
    And security query param "key" equals "API_KEY"

  Scenario Outline:
    Given endpoint "/detect" and method "get"
    And request query params
      | param | value           |
      | text  | <text_sample>   |
      | hint  | <language_code> |

    When the request is executed
    And response body has attributes
      | attribute | value                |
      | code      | 200                  |
      | lang      | <detected_lang_code> |

    Examples:
      | text_sample  | language_code | detected_lang_code |
      | Hello World! | en,de         | en                 |
      | Всем Привет! | ru,ua         | ru                 |




