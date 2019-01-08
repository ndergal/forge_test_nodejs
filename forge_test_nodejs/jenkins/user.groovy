import jenkins.model.*
import hudson.security.*
import hudson.model.User
import hudson.tasks.Mailer
def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
User u = hudsonRealm.createAccount(System.getenv("log_in"),System.getenv("password"))
instance.setSecurityRealm(hudsonRealm)
instance.save()
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, System.getenv("log_in"))
instance.setAuthorizationStrategy(strategy)
instance.save()
u.addProperty(new Mailer.UserProperty(System.getenv("address")))
