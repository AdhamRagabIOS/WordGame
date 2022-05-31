# WordGame
Babbel coding challenge

* How much time was invested

8 hours were invested building the game, I used MVVM-C, RxSwift.

* How was the time distributed (concept, model layer, view(s), game mechanics)

- 1 hour setting up the project ( Creating project, SwiftLint, SwiftGen, localizableStrings).
- 0.5 hour on layout.
- 0.5 hour on creating parser and data loader to decode the data and mapping it to a usable struct to check if the provided model is the correct translation.
- 2.5 hours on setting the architecture (I've used MVVM but learned Coordinator pattern, so used the newly learned coordinator pattern to create viewController and its viewModel).
- 1.5 hours on implementing the first deliverable logic
- 1 hour on implementing the first deliverable logic
- 1 hour on adding unit tests + documentation


* Decisions made to solve certain aspects of the game
  
- To solve the violation of Single Responsibility principle sometimes violated by MVVM, I used coordinator to make the viewController nothin but a dumb class that contains only the views.
- Also, to solve the 25% correct answers, the WordPairs needed to be shuffled, so I used "processQuestions" method to shuffle questions to contain only 25% correct translation so if there are 15 pairs only 3 will be correct.
And the others will be shuffled.
- I used RxSwift to listen to the buttons and map the answers to an enum to check whether the answer is correct or not. If it is correct, the viewModel will check whether I have reached the end of the questions of not. If not, it will increment the correct counter which is listened by the correct label in the viewController and go to the next question. Otherwise, it will increment the counter and end the game.
If the answer is incorrect, it will increase the incorrect counter and check whether the user reached the maximum number of failed attempts, if yes then it will end the game, otherwise it will increase the incorrect counter and go to the next question.
- To go to the next question, I have set a behaviourRelay object of type QuestionWord to and the viewController will listen if the question is changed than it will update the labels with the translations of the new questions.
- Adding the timer that will wait for 5 seconds, if no answer is provided, it will increment the incorrect counter and check for the max attempts or go to the next question.
- A viewController Factory was created to create viewControllers on demand when the coordinator send to create a new ViewController.

* Decisions made because of restricted time

- ViewControllerFactory should be more generic, due to time constraint and the fact that the app is only one viewcontroller, I created it with the instance of the viewController used in the game.
- I wanted to use builder pattern to initialize the viewModel for the VC, to reduce the coupling and make the viewModel unexposed to the viewController at all, but implementing this was a bit challenging so I used the normal way.
- A better way to do the application is to use state driven architecture.
- I wanted to add UITests but couldn't due to time constraint.

* What would be the first thing to improve or add if there had been more time

- Fix problems mentions in the (Decisions made because of restricted time) section.
- Add UITests.
- Make A better UI.
- Make a more abstract way for communcation between viewController and viewModel.
