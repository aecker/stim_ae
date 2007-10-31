function testError

error(struct('message','test','identifier','testError:myError','stack',dbstack))
