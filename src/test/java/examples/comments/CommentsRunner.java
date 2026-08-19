package examples.comments;

import com.intuit.karate.junit5.Karate;

class CommentsRunner {

    @Karate.Test
    Karate comments() {
        return Karate.run("comments").relativeTo(getClass());
    }
}
