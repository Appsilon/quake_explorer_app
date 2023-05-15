describe('Tests for quake select checkbox & dark mode toggle', () => {
  
  it('can check all quake types', () => {
    cy.visit("/");
    cy.wait(3000)
    cy.get('div.shiny-options-group')
      .first()
      .find('label.checkbox-inline')
      .as('checkbox_group')
    
    cy.get("@checkbox_group")
      .eq(0).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(1).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(1).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(2).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(2).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(3).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(3).click()
    cy.wait(2000)
    cy.get("@checkbox_group")
      .eq(0).click()
  })

  it('can toggle dark mode button', () => {
    cy.wait(2000)
    cy.get('button#app-btn_tog')
      .click()
    cy.wait(2000)
    cy.get('body').should('have.class', 'dark-theme')
  })
  
})


