package examples;

import com.intuit.karate.junit5.Karate;

class AllTestsRunner {

    @Karate.Test
    Karate all() {
        return Karate.run("classpath:examples").relativeTo(getClass());
    }
}
