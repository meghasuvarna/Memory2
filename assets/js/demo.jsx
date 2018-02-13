import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

export default function run_demo(root,channel) {
  ReactDOM.render(

    <Demo channel={channel}/>,root);}
  

  const modes = {1:"first click", 2:"second click", 3:"match", 4:"not matched"};

  class Card extends React.Component {
    render()
    {
      return <div className="block">
      <span>{this.props.card.flipped? this.props.card.value: " "} </span>
      </div>}

    }

    class Demo extends React.Component {
     constructor(props) {
       super(props);
       this.channel = props.channel;
       this.channel.join()
       .receive("ok", this.gotView.bind(this))
       .receive("error", resp => {console.log("unable to join",resp)});
       this.state = {

         cards: [],
         firstInput: [],
         secondInput: [],
         firstCardValue: "",
         mode: modes.a,
         clicks: 0,
         score: 0
       };
     }

     gotView(view)
     {
      console.log("New view", view);
      this.setState(view.game)
    }


    render() {

      const cardsRendered = this.state.cards.map((rowOfCards,rowindex) =>
        <tr>
        {rowOfCards.map((card, indexOfCardInRow)=><td onClick={()=>this.cardClick(card)}>
          <Card card={card}/>
          </td>)}
        </tr>);
      return (<div>


        <table>
        <tbody>
        {cardsRendered}

        </tbody>
        </table>
        <div>
        <label className="lblScore">Score:</label>
        <textbox className="score" id="lblScore">{this.state.score}</textbox>
        <label className="lblScore">Clicks:</label>
        <textbox className="score" id="lblCount">{this.state.clicks}</textbox>
        <br></br><br></br>
        <button  className="button" 
        onClick={ () => this.restartGame()}>Restart Game</button>
        </div>
        </div>)
    }

    restartGame()
    {

      this.channel.push("restart", {})
      .receive("ok",this.gotView.bind(this))


    }

    cardClick(card)
    { console.log("hi")
    console.log(card)
    if(this.state.cards[card.rowIndex][card.colIndex].flipped == false)
      { console.log("hello")
    this.channel.push("click", {row: card.rowIndex, col: card.colIndex})
    .receive("ok", this.gotView.bind(this));

  }
}




}







