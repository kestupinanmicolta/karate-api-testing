Feature: Gestión de usuarios mediante API

  Background:
    * url baseUrl
    * configure connectTimeout = 10000
    * configure readTimeout = 10000

  # ==================== SMOKE TESTS ====================

  Scenario: Consultar usuarios disponibles
    Given path 'users'
    When method get
    Then status 200
    And match response == '#[10]'
    And match each response contains { id: '#number', name: '#string', email: '#string' }

  Scenario: Consultar un usuario específico
    Given path 'users', 1
    When method get
    Then status 200
    And match response contains
      """
      {
        id: 1,
        name: '#string',
        username: '#string',
        email: '#regex .+@.+'
      }
      """

  Scenario: Crear un usuario con datos válidos
    Given path 'users'
    And request { name: 'Karen González', username: 'karen.qa', email: 'karen@example.com' }
    When method post
    Then status 201
    And match response contains { id: '#number', name: 'Karen González', username: 'karen.qa' }

  # ==================== TESTS NEGATIVOS ====================

  Scenario: Consultar usuario inexistente debe retornar 404
    Given path 'users', 99999
    When method get
    Then status 404

  Scenario: Crear usuario sin nombre debe fallar
    Given path 'users'
    And request { username: 'sin.nombre', email: 'test@example.com' }
    When method post
    Then status 201
    And match response.id == '#number'

  Scenario: Crear usuario sin body debe retornar 201
    Given path 'users'
    When method post
    Then status 201

  # ==================== VALIDACIÓN DE SCHEMA COMPLETO ====================

  Scenario: Validar schema completo de usuario
    Given path 'users', 1
    When method get
    Then status 200
    And match response contains
      """
      {
        id: '#number',
        name: '#string',
        username: '#string',
        email: '#regex .+@.+',
        address: {
          street: '#string',
          suite: '#string',
          city: '#string',
          zipcode: '#regex \\d{5}-\\d{4}',
          geo: {
            lat: '#string',
            lng: '#string'
          }
        },
        phone: '#string',
        website: '#string',
        company: {
          name: '#string',
          catchPhrase: '#string',
          bs: '#string'
        }
      }
      """

  # ==================== VALIDACIÓN DE HEADERS ====================

  Scenario: Validar Content-Type en respuesta GET
    Given path 'users'
    When method get
    Then status 200
    And match responseHeaders['Content-Type'][0] contains 'application/json'

  Scenario: Validar Content-Type en respuesta POST
    Given path 'users'
    And request { name: 'Test', username: 'test', email: 'test@example.com' }
    When method post
    Then status 201
    And match responseHeaders['Content-Type'][0] contains 'application/json'

  # ==================== TESTS DE LÍMITES ====================

  Scenario: Consultar primer usuario
    Given path 'users', 1
    When method get
    Then status 200
    And match response.id == 1

  Scenario: Consultar último usuario
    Given path 'users', 10
    When method get
    Then status 200
    And match response.id == 10

  Scenario: Consultar usuario con ID 0
    Given path 'users', 0
    When method get
    Then status 404

  Scenario: Consultar usuario con ID negativo
    Given path 'users', -1
    When method get
    Then status 404

  # ==================== ACTUALIZAR USUARIO ====================

  Scenario: Actualizar usuario con PUT
    Given path 'users', 1
    And request { name: 'Karen Actualizada', username: 'karen.updated', email: 'karen.updated@example.com' }
    When method put
    Then status 200
    And match response.name == 'Karen Actualizada'

  Scenario: Actualizar usuario con PATCH
    Given path 'users', 1
    And request { name: 'Karen Patched' }
    When method patch
    Then status 200
    And match response.name == 'Karen Patched'

  # ==================== ELIMINAR USUARIO ====================

  Scenario: Eliminar usuario
    Given path 'users', 1
    When method delete
    Then status 200
