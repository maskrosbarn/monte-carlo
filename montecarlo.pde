final int FRAMES_PER_SECOND = 15;
final int UPDATES_PER_SECOND = 15;


final int SIMULATION_COUNT = 250;
final int TIME_STEP_COUNT = 300;
final float S_ZERO = 400;
final float DRIFT = -.9;
final float VOLATILITY = .07;


final float DELTA_T = 1 / (float)TIME_STEP_COUNT;
final float BROWNIAN_EXPONENTIAL_COEFFICIENT = exp(DELTA_T * (DRIFT - pow(VOLATILITY, 2) * .5));


final int HISTOGRAM_BIN_COUNT = 50;
final float HISTOGRAM_PARTITION_WIDTH = 200;
final float HISTOGRAM_HEIGHT_PER_INTERVAL_ENTRY = 5 * (float)HISTOGRAM_PARTITION_WIDTH / (float)SIMULATION_COUNT;


final String SIMULATION_DESCRIPTION = String.format("Simulations: %d, Drift (μ): %.2f, Volatility (σ): %.2f", SIMULATION_COUNT, DRIFT, VOLATILITY);


float histogramIntervalWidth;


int time;
float timeStepWidth;
float[][] simulationPaths;
color[] simulationColours;


void setup ()
{
    size(1300, 650);
    frameRate(FRAMES_PER_SECOND);

    histogramIntervalWidth = height / (float)HISTOGRAM_BIN_COUNT;

    time = 0;
    timeStepWidth = (width - HISTOGRAM_PARTITION_WIDTH) / TIME_STEP_COUNT;

    simulationPaths = new float[SIMULATION_COUNT][TIME_STEP_COUNT];
    simulationColours = new color[SIMULATION_COUNT];

    for (int i = 0; i < SIMULATION_COUNT; i++)
    {
        simulationPaths[i] = generatePath(TIME_STEP_COUNT, VOLATILITY);
        simulationColours[i] = getRandomColour();
    }
}


void draw ()
{
    if (frameCount % (FRAMES_PER_SECOND / UPDATES_PER_SECOND) == 0)
    {
        time++;

        if (time == TIME_STEP_COUNT - 1)
        {
            noLoop();
            return;
        }
    }

    background(255);

    drawSimulations(time, simulationPaths, simulationColours);

    if (time > 0)
    {
        drawHistogram(time, HISTOGRAM_BIN_COUNT, simulationPaths);
    }

    fill(0);
    textSize(20);
    text(SIMULATION_DESCRIPTION, 10, height - 10);
}


float[] generatePath (int stepCount, float volatility)
{
    float[] path = new float[stepCount];

    path[0] = 1;

    for (int i = 1; i < stepCount; i++)
    {
        float wiener = randomGaussian() * sqrt(volatility);
        path[i] = path[i - 1] * BROWNIAN_EXPONENTIAL_COEFFICIENT * exp(volatility * wiener);
    }

    return path;
}


void drawSimulations (int currentTime, float[][] simulationPaths, color[] simulationColours)
{
    for (int i = 0; i < SIMULATION_COUNT; i++)
    {
        for (int j = 1; j < currentTime; j++)
        {
            float segmentHeadX = j * timeStepWidth;
            float segmentHeadY = S_ZERO * simulationPaths[i][j];

            float segmentTailX = (j - 1) * timeStepWidth;
            float segmentTailY = S_ZERO * simulationPaths[i][j - 1];

            stroke(simulationColours[i]);
            line(segmentTailX, getInvertedY(segmentTailY), segmentHeadX, getInvertedY(segmentHeadY));
        }
    }
}


void drawHistogram (int currentTime, int binCount, float[][] simulationPaths)
{
    float x = currentTime * timeStepWidth;

    stroke(0);
    line(x, 0, x, height);

    int[] binCounts = new int[binCount];
    java.util.Arrays.fill(binCounts, 0);

    float currentValueSum = 0;

    for (int i = 0; i < SIMULATION_COUNT; i++)
    {
        float currentValue = S_ZERO * simulationPaths[i][currentTime];
        float simulationCurrentValue = getInvertedY(currentValue);

        currentValueSum += currentValue;

        if (simulationCurrentValue < 0 || simulationCurrentValue > height)
        {
            continue;
        }

        binCounts[floor(simulationCurrentValue / histogramIntervalWidth)]++;
    }

    float currentValueMean = currentValueSum / SIMULATION_COUNT;
    float currentValueMeanYValue = getInvertedY(currentValueMean);

    for (int i = 0; i < binCount; i++)
    {
        stroke(0);
        fill(0);
        rect(x, i * histogramIntervalWidth, HISTOGRAM_HEIGHT_PER_INTERVAL_ENTRY * binCounts[i], histogramIntervalWidth);

        stroke(255, 0, 0);
        line(x, currentValueMeanYValue, width, currentValueMeanYValue);

        noStroke();
        fill(255, 0, 0);
        text(String.format("μ(t) = %.2f", currentValueMean), x + 5, currentValueMeanYValue - 5);
    }
}


color getRandomColour ()
{
    return color(random(100, 200), random(100, 200), random(100, 200));
}


float getInvertedY (float y)
{
    return height - y;
}