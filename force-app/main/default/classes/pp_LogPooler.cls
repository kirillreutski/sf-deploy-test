/**
 * Created by kirillreutski on 31.10.24.
 */

public without sharing class pp_LogPooler {
    private static final Integer depth = 2;
    private static final String CLASS_KEY = 'x_class';
    private static final String METHOD_KEY = 'method';

    public static pp_LogPooler getInstance(){
        return getInstance(null, null, 1);
    }
    public static pp_LogPooler getInstance(String overrideClass, String overrideMethod){
        return getInstance(overrideClass, overrideMethod, 1);
    }

    private static pp_LogPooler getInstance(String overrideClass, String overrideMethod, Integer depthIncrement){
        if (overrideClass == null || overrideMethod == null) {
            Map<String, String> methodName = getMethodName(depthIncrement);
            if (overrideClass == null) overrideClass = methodName.get(CLASS_KEY);
            if (overrideMethod == null) overrideMethod = methodName.get(METHOD_KEY);
        }
        return new pp_LogPooler(overrideClass, overrideMethod);
    }

    private String method = '';
    private String x_class = '';
    private pp_LogPooler(String x_class, String method) {
        this.method = method;
        this.x_class = x_class;
    }

    public void log(Object data) {
        Datetime n = Datetime.now();

        new pp_LogTail()
                .setData(data)
                .addData('method', method)
                .addData('x_class', x_class)
                .addData('dt', n)
                .addData('ts', n.getTime())
                .send();
    }

    private static Map<String, String> getMethodName(Integer depthIncrement){

        if (depth == null || depth < 1) return new Map<String, String>();

        Integer adjustedDepth = depth + depthIncrement;
        Decimal startTime = System.now().getTime();
        String stackTrace = null;
        try {
            throw new CustomException();
        }
        catch (Exception e) {
            stackTrace = e.getStackTraceString();
        }
        Decimal endTime = System.now().getTime();
        System.debug('LogPooler: ' + (endTime - startTime) + ' ms');
        List<String> parts = stackTrace.split('\n');

        if (parts.size() <= adjustedDepth) return new Map<String, String>();
        String methodName = parts[adjustedDepth].split(':')[0];

        List<String> methodNameParts = methodName.split('\\.');
        if (methodNameParts.size() < 3) return new Map<String, String>();
        return new Map<String, String> {CLASS_KEY => methodNameParts[1], METHOD_KEY => methodNameParts[2]};
    }

    public class CustomException extends Exception {}

}