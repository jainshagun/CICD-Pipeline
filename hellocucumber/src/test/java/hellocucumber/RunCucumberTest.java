package hellocucumber;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(plugin = {"pretty"};strict = false, features = &quot;features&quot;, format = { &quot;pretty&quot;,
        &quot;json:target/cucumber.json&quot; }, tags = { &quot;~@ignore&quot; })
public class RunCucumberTest {
}
