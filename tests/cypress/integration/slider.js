describe('Test for slider movement', () => {

  it('can move slider', () => {
    cy.visit("/");
  
    // Declaring vals for slider movement
    const rightarrows = '{rightarrow}'.repeat(1);
    const leftarrows = '{leftarrow}'.repeat(3);
    const sliderValues = [1, 2, 3, 4, 5, 6];
    
    cy.get('div#sidebar').find('div.react-container').eq(0)
      .find('div.ms-Slider-container')
      .find('div.ms-Slider-slideBox')
      .focus()
      .as('sliderarea')
    
    // Setting slider to 1
    cy.get('@sliderarea').type(leftarrows);
    cy.wait(500)
    
    // Looping over to check slider movement
    for (let i = 0; i < sliderValues.length-1; i++) {
      cy.get('@sliderarea').type(rightarrows);
      cy.wait(500)
      cy.get('@sliderarea')
        .invoke('attr', 'aria-valuenow')
        .should('eq', i+1)
    }
  
})
  
})


