package hellocucumber;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(strict = false, format = { "pretty", "json:target/cucumber.json" }, tags = { "~@ignore" })
public class RunCucumberTest {
}
