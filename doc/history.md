rails new todo --skip-test-unit --skip-bundle
cd todo

# édition du Gemfile

ajout de 

    gem 'therubyracer' # compilateur javascript

    group :test, :development do
      gem 'rspec-rails'
      gem 'capybara'
    end

    bundle install

    rails g rspec:install # configuration de rspec

édition de `spec/spec_helper.rb`, rajout de :

    require 'capybara/rspec'

# Commit initial
git init . 
git add . 
git commit -m "initial commit"

#Première fonctionnalité : création d'une tâche

Génération du test d'intégration :

    rails g integration_test CreateTask
    invoke  rspec
    spec/requests/create_tasks_spec.rb

## Écriture du test d'intégration

1. l'affichage de la page : en pointant son navigateur sur `new_task_path`, on
   veut un formulaire avec un champ name et un bouton pour créer la nouvelle
   tâche.
2. Si on remplit le formulaire avec 'task 1' dans le champ name, et que l'on
   clique sur le bouton, le navigateur doit afficher ensuite la page
   `tasks_path`

On joue le test, et on crée les classes et méthodes nécessaires pour que le test
ne renvoie plus d'erreur de syntaxe ( du type `unknown method` ou `unknown
Constant` )

On rajoute les routes introduites dans le test :

    get '/tasks/new', :controller => :tasks, :action => :new, :as => "new_task"
    get '/tasks', :controller => :tasks, :action => :index, :as => "tasks"

On génère le contrôleur `Tasks` avec les 2 actions `index` et `new`, juste pour
introduire le nom de la classe et des actions :

    rails g controller Tasks index new

Le générateur a rajouté des routes, je les supprime vu que je viens de les
définir.

Les erreurs restantes portent sur le contenu, il est temps de faire un peu de
code !

Le premier jeu d'exemple porte sur l'affichage du formulaire.
Nous allons décrire complètement le formulaire, en spécifiant pour le template
`spec/views/tasks/new.html.erb_spec.rb` les éléments suivants :

1. un formulaire avec l'id `new_task`, et la validation du formulaire doit créer
   la nouvelle tâche.
2. dans le formulaire, un champ avec le nom `task[name]`, et un label nommé
   `Name` référençant ce champ.
3. dans le formulaire, un bouton submit avec la valeur `Create Task`

Pour le 1, je décide de rajouter de suite la route correspondant à la création
d'une tâche :

    post '/tasks', :controller => :tasks, :action => :create

Je rajoute l'action `create` dans le contrôlleur, vide.

On implémente ensuite la vue. Je vous fournis 2 versions. Les 2 utilisent les
helpers rails qui permettent de générer les différents éléments des formulaires,
et qui sont décrits [ici]([http://guides.rubyonrails.org/form_helpers.html).

La première (`app/views/tasks/new.html.erb`) correspond à des formulaires basiques, on gère tout à la main.

La deuxième version (`app/views/tasks/new.html.erb_2`) utilise les conventions
rails, ce qui permet de raccourcir l'écriture si l'on suit les conventions. 
Voir [la section 2 du guide](http://guides.rubyonrails.org/form_helpers.html#dealing-with-model-objects)
pour une explication complète.

Je continue sur la première version.

Le test d'intégration `CreateTasks` demande à connaître l'action `create` dans
le contrôlleur:

    rspec spec/requests/create_tasks_spec.rb 
    ...F

    Failures:

      1) CreateTasks use new task form should display the todo list
         Failure/Error: click_button("Create Task")
         AbstractController::ActionNotFound:
           The action 'create' could not be found for TasksController

On la rajoute avec une implémentation vide. Le contrôleur doit d'après la
spécification rediriger ensuite vers l'affichage de la liste, on le décrit donc
dans la spec du contrôleur avant de la rajouter dans le code.

La spécification :

    describe TasksController do
      describe "POST create" do
        it "should redirect to the todo list" do
          post create
          response.should redirect_to tasks_path
        end
      end
    end

Le code :

    class TasksController
      def create
        redirect_to tasks_path
      end
    end
