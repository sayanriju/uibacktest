// if (Meteor.isClient) {
//   // counter starts at 0
//   Session.setDefault('counter', 0);
//
//   Template.hello.helpers({
//     counter: function () {
//       return Session.get('counter');
//     },
//     test1: function(){
//       return Session.get("counter") % 2;
//     },
//     test2: function(){
//       return !(Session.get("counter") % 2);
//     },
//     classList: function(){
//       // var ret = [];
//       // var cntr = Session.get("counter");
//       // if (cntr % 2)
//       //   retr.push("test1")
//       // else {
//       //   retr.push("test2")
//       // }
//       // console.log(ret);
//       // return ret.join('');
//       return ['test1','test2'].join(' ')
//     }
//   });
//
//   Template.hello.events({
//     'click button': function () {
//       // increment the counter when button is clicked
//       Session.set('counter', Session.get('counter') + 1);
//     }
//   });
// }
//
// if (Meteor.isServer) {
//   Meteor.startup(function () {
//     // code to run on server at startup
//   });
// }
// Template.jsonDumpModal.helpers({
//   jsonData: function(){
//     var q = Queue.findOne({ruleID:Session.get("ruleMaker.ruleID")});
//     return JSON.stringify(q);
//   }
// });
