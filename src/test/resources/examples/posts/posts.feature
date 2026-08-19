Feature: Gestión de posts mediante API

  Background:
    * url baseUrl
    * configure connectTimeout = 10000
    * configure readTimeout = 10000

  # ==================== SMOKE TESTS ====================

  Scenario: Consultar todos los posts
    Given path 'posts'
    When method get
    Then status 200
    And match response == '#[100]'
    And match each response contains { userId: '#number', id: '#number', title: '#string', body: '#string' }

  Scenario: Consultar post específico
    Given path 'posts', 1
    When method get
    Then status 200
    And match response contains
      """
      {
        userId: 1,
        id: 1,
        title: '#string',
        body: '#string'
      }
      """

  Scenario: Crear post válido
    Given path 'posts'
    And request { userId: 1, title: 'Post de prueba QA', body: 'Contenido del post para testing' }
    When method post
    Then status 201
    And match response contains { id: '#number', title: 'Post de prueba QA' }

  # ==================== TESTS NEGATIVOS ====================

  Scenario: Consultar post inexistente
    Given path 'posts', 99999
    When method get
    Then status 404

  Scenario: Crear post sin título
    Given path 'posts'
    And request { userId: 1, body: 'Sin título' }
    When method post
    Then status 201

  # ==================== FILTROS ====================

  Scenario: Filtrar posts por userId
    Given path 'posts'
    And param userId = 1
    When method get
    Then status 200
    And match each response contains { userId: 1 }

  # ==================== VALIDACIÓN DE SCHEMA ====================

  Scenario: Validar schema completo de post
    Given path 'posts', 1
    When method get
    Then status 200
    And match response contains
      """
      {
        userId: '#number',
        id: '#number',
        title: '#string',
        body: '#string'
      }
      """

  # ==================== ACTUALIZAR POST ====================

  Scenario: Actualizar post con PUT
    Given path 'posts', 1
    And request { userId: 1, title: 'Post Actualizado', body: 'Contenido actualizado' }
    When method put
    Then status 200
    And match response.title == 'Post Actualizado'

  Scenario: Actualizar post con PATCH
    Given path 'posts', 1
    And request { title: 'Post Parcheado' }
    When method patch
    Then status 200
    And match response.title == 'Post Parcheado'

  # ==================== ELIMINAR POST ====================

  Scenario: Eliminar post
    Given path 'posts', 1
    When method delete
    Then status 200
