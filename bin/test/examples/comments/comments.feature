Feature: Gestión de comentarios mediante API

  Background:
    * url baseUrl
    * configure connectTimeout = 10000
    * configure readTimeout = 10000

  # ==================== SMOKE TESTS ====================

  Scenario: Consultar todos los comentarios
    Given path 'comments'
    When method get
    Then status 200
    And match response == '#[500]'
    And match each response contains { postId: '#number', id: '#number', name: '#string', email: '#regex .+@.+', body: '#string' }

  Scenario: Consultar comentario específico
    Given path 'comments', 1
    When method get
    Then status 200
    And match response contains
      """
      {
        postId: 1,
        id: 1,
        name: '#string',
        email: '#regex .+@.+',
        body: '#string'
      }
      """

  # ==================== FILTROS ====================

  Scenario: Filtrar comentarios por postId
    Given path 'comments'
    And param postId = 1
    When method get
    Then status 200
    And match each response contains { postId: 1 }

  # ==================== TESTS NEGATIVOS ====================

  Scenario: Consultar comentario inexistente
    Given path 'comments', 99999
    When method get
    Then status 404

  # ==================== VALIDACIÓN DE SCHEMA ====================

  Scenario: Validar schema completo de comentario
    Given path 'comments', 1
    When method get
    Then status 200
    And match response contains
      """
      {
        postId: '#number',
        id: '#number',
        name: '#string',
        email: '#regex .+@.+',
        body: '#string'
      }
      """

  # ==================== VALIDACIÓN DE EMAIL ====================

  Scenario: Validar formato de email en comentarios
    Given path 'comments'
    When method get
    Then status 200
    And match each response contains { email: '#regex [a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}' }
