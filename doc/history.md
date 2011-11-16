# Création du projet
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

## Spécification de la vue

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

Mon test d'intégration passe, je commite !

    git add .
    git commit -m "CreateTask scenario"

# 2e scénario : affichage de la liste des tâches

## Description du scénario :

Étant donné que 3 tâches existent dans la base
Si je visite le lien /tasks (i.e. `tasks_path`)
Alors je dois voir le nom des 3 tâches 

    rails g integration_test ListTasks

Et on traduit en code la description ci-dessus.

Il faut introduire le modèle pour pouvoir créer la précondition du scénario :

    rails g model Task name:string done:boolean

Le générateur crée la migration, il faut migrer la base de données de test et
celle de développement :

    RAILS_ENV=test rake db:migrate
    rake db:migrate # mode de développement par défaut

Le test d'intégration doit alors tourner correctement, et signaler :

    rspec spec/requests/list_tasks_spec.rb 
    F

    Failures:

      1) ListTasks GET /list_tasks should display each task name
         Failure/Error: @tasks.each{|t| page.should have_content t.name}
           expected there to be content "task1" in "Todo\n\nTasks#index\nFind me in app/views/tasks/index.html.erb\n\n\n"

## Spécification de la vue

Nous allons maintenant spécifier la vue. La spécification de la vue doit
introduire le balisage HTML qui va être utilisé dans le template. Il faut
normalement partir d'une représenation envisagé (tracée sur une feuille de
papier par exemple).

Ici, nous avons une liste d'éléments relativement simples à afficher, une liste
HTML sera suffisante. (`<ul>` Unnumbered List). On la repère dans la page avec
l'id `tasks`

Donc en supposant que le contrôleur nous passe 3 objets Task dans la variable
`@tasks`, je veux afficer trois fois le tag `<li>` (List Item) avec le nom de la
liste à l'intérieur. Chaque li est identifié avec un dérivé de l'identifiant base de données
de la tâche.

Par exemple, la tâche d'id (base de donnée) 4 est identifé par l'id (HTML)
`task_4`

Cette spécification décrite sous forme de code est à voir dans
`spec/views/tasks/index.html.erb_spec.rb`

À noter que pour éviter de faire appel à la couche modèle, on utilise
`stub_model` fourni par rspec-rails, c.f. 
[la documentation](https://www.relishapp.com/rspec/rspec-rails/docs/mocks/stub-model)
pour plus de détails.

L'implémentation de la vue est ensuite triviale.

## Spécification du contrôleur

Reste l'action `index` du contrôleur à spécifier.

Dans `index`, le contrôleur doit :

1. récupérer les tâches en faisant appel à `Task.all`
2. affecter la liste des tâches à la variable `@tasks`

Pour le 2e example, il faut savoir quel est le résultat de `Task.all`, on
remplace donc l'appel de `all` sur `Task` (stub).

Là encore, le code est trivial.

On vérifie que le test d'intégration passe, et on conclut notre 2e scénario en
commitant le tout.

# Compléter la démo

On peut créer des tâches, et les lister, sur 2 vues différentes.
Pour pouvoir manipuler complètement l'application sans rentrer d'url
manuellement dans le navigateur, je vais rajouter :

1. Une nouvelle route qui associe le chemin `/` à `Task#index`
2. Un lien dans la vue liste qui permette de lancer la création de la liste.

On rajoute 2 au test d'intégration `ListTasks`, puis à la spécification de la
vue et à la vue. À noter que pour 1, on ne peut le spécifier dans un test
d'intégration, qui suppose déjà fixé la partie routage.

Il est possible de spécifier le routage avec rspec, voir
[routing-specs](https://www.relishapp.com/rspec/rspec-rails/docs/routing-specs).
Je me contente de rajouter la route directement dans `config/routes.rb`:

    root :to => 'tasks#index'

Voir [le guide sur le routage](http://guides.rubyonrails.org/routing.html#using-root)

Il faut également détruire le fichier `public/index.html` qui sinon est utilisé
pour la route `/`.

Avec ces modification, il est possible de faire tourner notre application. Le
problème restant est l'action `create` a été laissé blanche, ce qui fait que
l'on ne crée pas grand chose.

On peut utiliser la console de rails pour créer quelques tâches manuellement
dans la base de l'environnement de développement, ce qui nous permettra de
visualiser notre liste.

    rails console
    >> 3.times{|i| Task.create(:name => "Task #{i}")}
    >> exit

Pour lancer l'application :

    rails server

Il suffit alors de pointer son navigateur sur `http://localhost:3000`, et la
liste de nos 3 tâches s'affiche. Si la page d'acceuil de Rails s'affiche, c'est
que vous n'avez pas détruit `public/index.html`.

# Finir la création de liste

On va compléter le test d'intégration en rajoutant un jeu d'exemple qui correspondra au scénario complet de la création d'une liste: 

1. visiter la page affichant la liste des tâches
2. cliquer sur le lien
3. remplir le formulaire sur la nouvelle page
4. se retrouver sur la page affichant la liste, et voir la liste créée
   s'affichier

      describe "after a new task has been created" do
        before(:each) do
          visit tasks_path
          click_link("Create a new Task")
          current_path.should == new_task_path
          fill_in("Name", :with => "task 1")
          click_button("Create Task")
          current_path.should == tasks_path
        end

        it "should display the new task in the list" do
          page.should have_content("task 1")
        end
      end

Ce scénario récapitule les 2 précédents, et teste juste le résultat.
En jouant le test, on obtient :

    rspec spec/requests/create_tasks_spec.rb 
    ....F

    Failures:

      1) CreateTasks after a new task has been created should display the new task in the list
         Failure/Error: page.should have_content("task 1")
           expected there to be content "task 1" in "Todo\n\nTasks#index\n\nCreate a new Task\n\n\n"

On va maintenant spécifier au contrôleur de faire son travail.

Pour cela, commençons par regarder le format des paramètres renvoyés par le
formulaire dans la vue `app/views/tasks/new.html.erb`.

Pour savoir le format exact renvoyè, on peut par exemple :

* dans le contrôleur: enlever la redirection présenter vers `tasks_path`.  On
rajoute `render :text => params.inspect` pour que le rendu de l'action soit le
contenu des paramètres.
* démarrer l'application en mode développement avec `rails server`, et créer une
nouvelle tâche.

Le rendu est alors le contenu de params :

    {"utf8"=>"✓", "authenticity_token"=>"QpnPVk2BYEcDxqdACX+3Vg3u0Dv+hlPTygHA5TLGV+4=", "task"=>{"name"=>"task_name"}, "commit"=>"Create Task", "controller"=>"tasks", "action"=>"create"}

En particulier, on voit que `params["task"]` contient la description des
éléments pour créer la nouvelle tâche.

Je commite ici pour que vous puissiez voir l'état des fichiers.

On peut embrayer sur l'écriture de la spécification du contrôleur.

Dans la spécification, pour simuler la requête HTTP avec les paramètres
corrects, on va écrire :

    post :create, {"task" => {"name" => "task_name"}}

Le 2e argument représente les paramètres reçus, i.e. la valeur dans le code de
l'action de `params`. 

La spécification de l'action `create` du contrôleur devient alors :

1. créer un nouvel objet Task à partir des paramètres.
2. rediriger le client vers la liste des tâches `tasks_path`.
